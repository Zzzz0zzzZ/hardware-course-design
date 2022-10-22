module test_aReg;
  
  reg clk;
  reg [31:0] alu_dataOut_1;
  wire [31:0] aReg_out;
  
  aReg aReg1(clk, alu_dataOut_1, aReg_out);
  initial
  begin
    clk = 0;
    alu_dataOut_1 = 32'h1234_5678;
    
    # 200 
    clk = 1;
    
  end
  
endmodule
