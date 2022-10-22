module mips(clk, reset);
  input clk;
  input reset;
  
  // output signal
  // ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr, condition_jdg, pc_p8);
  wire [31:0] insout;
  wire [15:0] imm16;
  wire [5:0] opcode;
  wire [5:0] funct;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [31:0] jalAddr;
  wire [31:0] pc_p8;
  // controller(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31, bgezal_31);

  wire RegDst;
  
wire RegWrite;
  
wire ALUSrc;
  wire MemtoReg;
  wire MemWrite;
  wire Branch;  //nPC_sel
  wire [2:0] ALUOp;
  wire [1:0] ExtOp;
  wire J;
  wire WriteToGPR_30;
  wire write_31;
  wire jr_ctrl;
  wire bgezal_31;
  
  // gpr(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30, write_31, jalAddr, bgezal_31, pc_p8);
  wire [31:0] gprOut_1;
  wire [31:0] gprOut_2;
  // alu( A, B, ALUOp, zero, alu_res, overflow, condition_jdg)
  wire zero;
  wire [31:0] alu_res;
  wire overflow;
  wire condition_jdg;
  // ext(imm16, ExtOp, ext32);
  wire [31:0] ext32;
  // dm(clk, reset, MemWrite, din, addr, dout);
  wire [31:0] dm_out;
  // mux_2c1_32bit(sel, din_0, din_1, dout);
  wire [31:0] DataToGPR;
  wire [31:0] muxResToALU;
  // mux_2c1_5bit(sel, din_0, din_1, dout);
  wire [4:0] AddrToGPR;
  
  // connect all
  // ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr, condition_jdg, pc_p8);
  ifu ifu_wsz(clk, reset, Branch, zero, insout, J, opcode, rs, rt, rd, funct, imm16, jr_ctrl, gprOut_1, jalAddr, condition_jdg, pc_p8);
  // controller(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31, bgezal_31);
  controller ctrl_wsz(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31, bgezal_31);
  // gpr(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30, write_31, jalAddr, bgezal_31, pc_p8);
  gpr gpr_wsz(clk, reset, RegWrite, DataToGPR, AddrToGPR, rs, rt, gprOut_1, gprOut_2, WriteToGPR_30, write_31, jalAddr, bgezal_31, pc_p8);
  // mux_2c1_5bit(sel, din_0, din_1, dout);
  mux_2c1_5bit addrIn_for_gpr(RegDst, rt, rd, AddrToGPR);
  // alu( A, B, ALUOp, zero, alu_res, overflow, condition_jdg)
  alu alu_wsz( gprOut_1, muxResToALU, ALUOp, zero, alu_res, overflow, condition_jdg);
  // mux_2c1_32bit(sel, din_0, din_1, dout);
  mux_2c1_32bit din_for_alu_b(ALUSrc, gprOut_2, ext32, muxResToALU);
  // ext(imm16, ExtOp, ext32);
  ext ext_wsz(imm16, ExtOp, ext32);
  // dm(clk, reset, MemWrite, din, addr, dout);
  dm dm_wsz(clk, reset, MemWrite, gprOut_2, alu_res, dm_out);
  // mux_2c1_32bit(sel, din_0, din_1, dout);
  mux_2c1_32bit din_for_gprData(MemtoReg, alu_res, dm_out, DataToGPR);


endmodule



