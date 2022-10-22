module test_mips;
  
  reg clk,rst;
  

  mips mips1(clk, rst);
  
  initial
  begin
    clk = 0;
    rst = 0;
    #50
    rst = 1;
    # 70
    rst = 0;
  
  end
  
  always
    #100 clk = ~clk;
    
endmodule

