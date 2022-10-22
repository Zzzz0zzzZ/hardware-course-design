module im_1k(addr, dout);
  
  input [9:0] addr;
  output [31:0] dout;
  
  reg [7:0] im[1023:0];
  
  initial
  begin
    //$readmemh("p1-test.txt", im);
    //$readmemh("test-lbsb.txt", im);
    //$readmemh("p2-test.txt", im);
    $readmemh("p2addcons.txt", im);
  end
  
  assign dout = {im[addr], im[addr+1], im[addr+2], im[addr+3]};
  
endmodule
