module test_mips;
  reg clk;
  reg reset;
  
  mips mips_1(clk, reset);
  
  initial
    begin
      clk = 0;
      reset = 0;
      //#90 reset = 1;
      //#90 reset = 0;
    end
    
    
  always
    #50
    clk = ~clk;
  
  
endmodule