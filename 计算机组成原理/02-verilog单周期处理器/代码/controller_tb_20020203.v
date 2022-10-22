module test_controller;
  reg [5:0] opcode;
  reg [5:0] funct;
  reg overflow;
  wire RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch;
  wire [2:0] ALUOp;
  wire [1:0] ExtOp;
  wire J;
  wire WriteToGPR_30;
  
controller ctrl1(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30);
  initial
  begin
    opcode = 6'b000000;
    funct = 6'b101010;
    overflow = 0;
    #30
    overflow = 1;
    /*
    #30
    opcode = 6'b000000;
    funct = 6'b100011;
    #30
    opcode = 6'b001101;
    #30
    opcode = 6'b100011;
    #30
    opcode = 6'b101011;
    #30
    opcode = 6'b000100;
    #30
    opcode = 6'b001111;
    #30
    opcode = 6'b000010;
    */
  end
endmodule
  