module test_dm;
  
  reg clk, reset, MemWrite;
  reg [31:0] din;
  reg [31:0] addr;
  wire [31:0] dout;
  
  dm dm_1(clk, reset, MemWrite, din, addr, dout);  
  
  initial
    begin
      clk = 0;
      reset =0;
      MemWrite = 0;
      
      # 30 
      reset = 1;
      # 30 
      reset = 0;
      # 30
      MemWrite = 1;
      din = 32'h1234_5678;
      addr = 32'b0000_0000;
      # 5
      MemWrite = 0;
      # 30
      MemWrite = 1;
      din = 32'h8765_4321;
      addr = 32'b0000_0100;
      # 30
      reset = 1;
      # 30
      reset = 0;
    end
    
  always
    # 10 clk = ~clk;


endmodule

