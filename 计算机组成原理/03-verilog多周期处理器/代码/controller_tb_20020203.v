module test_ctrl;
  reg clk, rst;
  reg [5:0] opcode, funct;
  reg zero;
  wire [1:0] RegDst, MemToReg, npc_sel, ALUOp, ExtOp;
  wire RegWrite, ALUSrc, MemWrite, write_30, pcwr, irwr;
  wire islb, issb;
  
  controller ctrl1(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb);
  
  initial
  begin
    clk = 0;
    rst = 0;
    opcode = 6'b000000;
    funct = 6'b001000;
    zero = 1;
    
  end
  
  always
    #50 clk = ~clk;
endmodule
