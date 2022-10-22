module mips(clk, rst);
  input clk;
  input rst;
  // output signal
  // module pc(clk, pcwr, pcin, pcout);
  wire [31:0] pcout;
  // module im_1k(addr, dout);
  wire [31:0] imout;
  // module ir(clk, irwr, imin, irout);
  wire [31:0] irout;
  // module gpr(clk, rst, gprwr, MemToReg, RegDst, rs, rt, rd, write_30, pc_p4, aluReg_out, dmReg_out, overflow, dataOut_1, dataOut_2);
  wire [31:0] dataOut_1, dataOut_2;
  // module aReg(clk, alu_dataOut_1, aReg_out); module bReg(clk, alu_dataOut_2, bReg_out);
  wire [31:0] aReg_out,bReg_out;
  // module alu(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res);
  wire zero, overflow;
  wire [31:0] alu_res;
  // module aluReg(clk, alu_res, aluReg_out, overflow, overflowReg);
  wire [31:0] aluReg_out;
  wire overflowReg;
  // module dm_1k(addr, din, we, clk, dout);
  wire [31:0] dmout;
  // module dr(clk, dmout, drout);
  wire [31:0] drout;
  // module npc(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout);
  wire [31:0] npc_out;
  // module ext(imm16, ExtOp, ext32);
  wire [31:0] ext32;
  // module controller(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb);
  wire [1:0] RegDst, MemToReg, npc_sel, ALUOp, ExtOp;
  wire RegWrite, ALUSrc, MemWrite, write_30, pcwr, irwr;
  wire islb, issb;
  wire [31:0] dm_datain;
  wire nCondition;
  
  // connect all
  // module pc(clk, pcwr, pcin, pcout);
  pc pc_wsz(clk,pcwr,npc_out,pcout);
  // module im_1k(addr, dout);
  im_1k im_wsz(pcout[9:0],imout);
  // module ir(clk, irwr, imin, irout);
  ir ir_wsz(clk,irwr,imout, irout);
  // module gpr(clk, rst, gprwr, MemToReg, RegDst, rs, rt, rd, write_30, pc_p4, aluReg_out, dmReg_out, overflow, dataOut_1, dataOut_2);
  gpr gpr_wsz(clk,rst,RegWrite,MemToReg,RegDst,irout[25:21],irout[20:16],irout[15:11],write_30,pcout,aluReg_out,drout,overflowReg,dataOut_1, dataOut_2);
  // module aReg(clk, alu_dataOut_1, aReg_out); module bReg(clk, alu_dataOut_2, bReg_out);
  aReg aReg_wsz(clk, dataOut_1, aReg_out);
  bReg bReg_wsz(clk, dataOut_2, bReg_out);
  // module alu(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30);
  alu alu_wsz(aReg_out, bReg_out, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30, nCondition);
  // module aluReg(clk, alu_res, aluReg_out, overflow, overflowReg);
  aluReg aluReg_wsz(clk, alu_res, aluReg_out, overflow, overflowReg);
  // module dm_1k(addr, din, we, clk, dout);   din-->dm_datain
  dm_1k dm_wsz(aluReg_out[9:0], dm_datain, MemWrite, clk, dmout);
  // module dr(clk, dmout, drout);
  dr dr_wsz(clk, dmout, drout, islb);
  // module npc(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout);
  npc npc_wsz(rst, dataOut_1, pcout, npc_sel, zero, irout, npc_out, nCondition);
  // module ext(imm16, ExtOp, ext32);
  ext ext_wsz(irout[15:0], ExtOp, ext32);
  // module controller(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb);
  controller controller_wsz(clk,rst,irout[31:26], irout[5:0], zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb, nCondition);
  // module muxdmin(bReg_out, dmout_data, issb, dm_datain);
  muxdmin muxdmin_wsz(bReg_out, dmout, issb, dm_datain);

  
endmodule
