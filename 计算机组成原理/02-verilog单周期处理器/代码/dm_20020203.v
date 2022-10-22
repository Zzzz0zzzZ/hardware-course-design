module dm(clk, reset, MemWrite, din, addr, dout);
  input clk, reset, MemWrite;
  input [31:0] din;
  input [31:0] addr;
  output [31:0] dout;
  
  reg [7:0] dm[1023:0];
  
  wire [9:0] real_addr;
  assign real_addr = addr[9:0];
  assign dout = {dm[real_addr+3], dm[real_addr+2], dm[real_addr+1], dm[real_addr]}; 
  
  integer i;
  
  initial
    begin
      for(i = 0; i < 1024; i = i + 1) dm[i] <= 0;
    end
    
  always@(posedge clk, posedge reset)
    begin
      if(reset)
        begin
          for(i = 0; i < 1024; i = i + 1) dm[i] <= 0;  
        end
      else
        begin
          if(MemWrite)
            begin
              $display("Writing to dm......");
              {dm[real_addr+3], dm[real_addr+2], dm[real_addr+1], dm[real_addr]} <= {din[31:24], din[23:16], din[15:8], din[7:0]};
              /*
              dm[real_addr+3] <= din[31:24];
              dm[real_addr+2] <= din[23:16];
              dm[real_addr+1] <= din[15:8];
              dm[real_addr] <= din[7:0];
              */
            end
          else
            begin
              $display("Warning: Failed to write, because MemWrite is disabled.") ; 
            end
        end
    end

endmodule

  
  
   
