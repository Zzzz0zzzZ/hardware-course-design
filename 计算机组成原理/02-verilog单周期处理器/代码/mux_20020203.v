module mux_2c1_32bit(sel, din_0, din_1, dout);
  input sel;
  input [31:0] din_0;
  input [31:0] din_1;
  output reg [31:0] dout;
  
  always@(*)
    begin
      if(sel == 0)
        begin
          dout = din_0;
        end
        
      else
        begin
          dout = din_1;  
        end

    end

endmodule

module mux_2c1_5bit(sel, din_0, din_1, dout);
  input sel;
  input [4:0] din_0;
  input [4:0] din_1;
  output reg [4:0] dout;
  
  always@(*)
    begin
      if(sel == 0)
        begin
          dout = din_0;
        end
        
      else
        begin
          dout = din_1;  
        end

    end

endmodule

module mux_3c1_5bit(sel, din_0, din_1, din_2, dout);
  input [1:0] sel;
  input [4:0] din_0;
  input [4:0] din_1;
  input [4:0] din_2;
  output reg [4:0] dout;
  
  always@(*)
    begin
      if(sel == 2'b00)
        begin
          dout = din_0;  
        end
      else if(sel == 2'b01)
        begin
          dout = din_1;  
        end
      else if(sel == 2'b10)
        begin
          dout = din_2;  
        end
      else
        begin
          $display("Warning: invalid sel for mux_3c1_5bit");
        end
        
    end
  
endmodule