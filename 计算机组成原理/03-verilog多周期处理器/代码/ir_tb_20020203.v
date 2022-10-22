module test_ir;
  reg clk,irwr;
  reg [31:0] imin;
  wire [31:0] irout;

  ir ir1(clk, irwr, imin, irout);
    initial
    begin
      clk = 0;
      irwr = 0;
      imin = 32'h1234_5678;
      
      # 200
      irwr = 1;
      
    end
    
    always
      # 50 
      clk = ~clk;
      
endmodule