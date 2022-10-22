module test_ext;
  reg [15:0] imm16;
  reg [1:0] ExtOp;
  wire [31:0] ext32;
  
  ext ext_1(imm16, ExtOp, ext32);
  
  initial
  begin
    imm16 = 16'b1101_0101_0101_0101;
    ExtOp = 2'b00;  //  0 extension
    
    #30 //  sign extension
    ExtOp = 2'b01;
    
    #30 //  lui operataion
    ExtOp = 2'b10;
    
    #30 //  default
    ExtOp = 2'b11;
    
  end
  


endmodule

  
