module ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr, condition_jdg, pc_p8);
  
  
  input clk, reset, npc_sel, zero, j;
  input jr_ctrl;
  input [31:0] jrAddr;
  input condition_jdg;

  output [31:0] insout;
  
  output [5:0] opcode;
  output [4:0] rs;
  output [4:0] rt;
  output [4:0] rd;
  output [5:0] funct;
  output [15:0] imm16;
  output [31:0] jalAddr;
  output [31:0] pc_p8;
  
  reg [31:0] pc;
  reg [7:0] im[1023:0];
  wire [31:0] pcnew, t1, t0, extout, temp, pcnewnew, j_addr, pcnewnewnew, pc_nnnn;
  
  wire [15:0] imm;
  wire [31:0] bgezal_addr;
  
  
  initial
    begin
      //$readmemh("addCons.txt", im);
      $readmemh("p1-test.txt", im);
    end
  assign insout = {im[pc[9:0]],im[pc[9:0]+1],im[pc[9:0]+2],im[pc[9:0]+3]};
  assign imm = insout[15:0];
  assign temp = {{16{imm[15]}},imm};
  assign extout = temp << 2;
  
  assign opcode = insout[31:26];
  assign funct = insout[5:0];
  assign rs = insout[25:21];
  assign rt = insout[20:16];
  assign rd = insout[15:11];
  assign imm16 = insout[15:0];
  assign jalAddr = pc + 4;
  assign pc_p8 = pc + 8;
  
  initial
    begin
      pc <= 32'h0000_3000;
    end
    
  always@(posedge clk, posedge reset)
  begin
    if(reset) pc <= 32'h0000_3000;
    else  pc <= pc_nnnn;
  end
  
  assign pc_nnnn = (condition_jdg == 1) ? bgezal_addr : pcnewnewnew;
  assign pcnewnewnew = (jr_ctrl == 1) ? jrAddr : pcnewnew;
  assign pcnewnew = (j == 1) ? j_addr : pcnew;
  assign pcnew = (npc_sel && zero) ? t1 : t0;
  assign j_addr = {t0[31:28], insout[25:0], 2'b00};   // ????j?jal??
  assign t0 = pc + 4;
  assign t1 = t0 + extout;
  assign bgezal_addr = t0 + {{14{imm[15]}}, extout};
  
  
  
  
endmodule
  
  
