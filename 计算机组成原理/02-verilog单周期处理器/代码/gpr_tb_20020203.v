module test_gpr;
  
  reg clk, reset, RegWrite;
  reg WriteToGPR_30;
  reg [31:0] writeData;
  reg [4:0] writeAddr;
  reg [4:0] readAddr_1;
  reg [4:0] readAddr_2;
  wire [31:0] dataOut_1;
  wire [31:0] dataOut_2;
  
  gpr gpr_1(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30);  
  
  initial
    begin
      clk = 0;
      reset = 0;
      RegWrite = 1;
      WriteToGPR_30 = 0;
      # 50
      writeData = 32'h1234_5678;
      writeAddr = 5'b00010;
      # 50
      writeData = 32'h8765_4321;
      writeAddr = 5'b00011;
      # 50
      readAddr_1 = 5'b00010;
      readAddr_2 = 5'b00011;
      # 50
      readAddr_1 = 5'b00000;
      # 50
      WriteToGPR_30 = 1;
      
    end
    
    
  always
    #30 clk = ~clk;
  
endmodule

