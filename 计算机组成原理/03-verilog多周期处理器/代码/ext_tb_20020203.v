module test_ext;
  
  reg [15:0] imm16;
  reg [1:0] ExtOp;
  wire [31:0] ext32;
  
  ext ext1(imm16, ExtOp, ext32);
  
  initial
  begin
    imm16 = 16'hffff;
    ExtOp = 2'b00;
    #100
    ExtOp = 2'b01;
    #100
    ExtOp = 2'b10;
    #100
    ExtOp = 2'b11;
    
  end
  
endmodule

