module controller(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb, nCondition);
  input clk, rst;
  input [5:0] opcode, funct;
  input zero;
  input nCondition;
  output [1:0] RegDst, MemToReg, npc_sel, ALUOp, ExtOp;
  output RegWrite, ALUSrc, MemWrite, write_30, pcwr, irwr;
  output islb, issb;
  
  parameter [3:0] S0 = 4'b0000;
  parameter [3:0] S1 = 4'b0001;
  parameter [3:0] S2 = 4'b0010;
  parameter [3:0] S3 = 4'b0011;
  parameter [3:0] S4 = 4'b0100;
  parameter [3:0] S5 = 4'b0101;
  parameter [3:0] S6 = 4'b0110;
  parameter [3:0] S7 = 4'b0111;
  parameter [3:0] S8 = 4'b1000;
  parameter [3:0] S9 = 4'b1001;
  // big and
  // funct[5] & funct[4] & funct[3] & funct[2] & funct[1] & funct[0];
  // opcode[5] & opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0];
  wire Rtype = ~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
  wire addu = Rtype & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & ~funct[1] & funct[0];
  wire subu = Rtype & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & funct[1] & funct[0];
  wire slt = Rtype & funct[5] & ~funct[4] & funct[3] & ~funct[2] & funct[1] & ~funct[0];
  wire jr = Rtype & ~funct[5] & ~funct[4] & funct[3] & ~funct[2] & ~funct[1] & ~funct[0];
  wire ori = ~opcode[5] & ~opcode[4] & opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
  wire lw = opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0];
  wire sw = opcode[5] & ~opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & opcode[0];
  wire beq = ~opcode[5] & ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & ~opcode[0];
  wire lui = ~opcode[5] & ~opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0];
  wire j = ~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];
  wire addi = ~opcode[5] & ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
  wire addiu = ~opcode[5] & ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];
  wire jal = ~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0];
  wire lb = opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
  wire sb = opcode[5] & ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
  wire bltzal = ~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];
  // fsm
  reg [3:0] cur_state, next_state;
  always@(posedge clk, posedge rst)
  begin
    if(rst)
      begin
        cur_state <= S0;
      end
    else
      begin
        cur_state <= next_state;
      end
  end
  
  always@(*)
  begin
    case(cur_state)
      S0:
        begin
          next_state = S1;
        end
      S1:
        begin
          if(lw | sw | lb | sb)
            begin
              next_state = S2;
            end
          else if(addu | subu | ori | lui | addi | addiu | slt) // Rtype or Itype
            begin
              next_state = S6;
            end
          else if(beq | jr | bltzal)
            begin
              next_state = S8;
            end
          else if(j | jal )
            begin
              next_state = S9;
            end
        end
      S2:
        begin
          if(lw | lb)
            begin
              next_state = S3;
            end
          else if(sw | sb)
            begin
              next_state = S5;
            end
        end
      S3:
        begin
          next_state = S4;
        end
      S4:
        begin
          next_state = S0;
        end
      S5:
        begin
          next_state = S0;
        end
      S6:
        begin
          if(addu | subu | ori | lui | addi | addiu | slt)
            begin
              next_state = S7;
            end
        end
      S7:
        begin
          next_state = S0;
        end
      S8:
        begin
          next_state = S0;
        end
      S9:
        begin
          next_state = S0;
        end
      default:
        begin
          next_state = S0;
        end
    endcase
  end
  // big or
  //output [1:0] RegDst, MemToReg, npc_sel, ALUOp, ExtOp;
  //output RegWrite, ALUSrc, MemWrite, write_30, pcwr, irwr, islb, issb;
  assign s0=(~cur_state[3])&(~cur_state[2])&(~cur_state[1])&(~cur_state[0]);
  assign s1=(~cur_state[3])&(~cur_state[2])&(~cur_state[1])&( cur_state[0]);
  assign s2=(~cur_state[3])&(~cur_state[2])&( cur_state[1])&(~cur_state[0]);
  assign s3=(~cur_state[3])&(~cur_state[2])&( cur_state[1])&( cur_state[0]);
  assign s4=(~cur_state[3])&( cur_state[2])&(~cur_state[1])&(~cur_state[0]);
  assign s5=(~cur_state[3])&( cur_state[2])&(~cur_state[1])&( cur_state[0]);
  assign s6=(~cur_state[3])&( cur_state[2])&( cur_state[1])&(~cur_state[0]);
  assign s7=(~cur_state[3])&( cur_state[2])&( cur_state[1])&( cur_state[0]);
  assign s8=( cur_state[3])&(~cur_state[2])&(~cur_state[1])&(~cur_state[0]);
  assign s9=( cur_state[3])&(~cur_state[2])&(~cur_state[1])&( cur_state[0]);
  //
  assign RegDst[1] = jal | bltzal;
  assign RegDst[0] = addu | subu | slt;
  assign MemToReg[1] = jal | bltzal;
  assign MemToReg[0] = lw | lb;
  assign npc_sel[1] = (jr | j | jal) & (~s0);
  assign npc_sel[0] = (beq | jr | bltzal) & (~s0);
  assign ALUOp[1] = ori | slt; 
  assign ALUOp[0] = subu | beq | slt; 
  assign ExtOp[1] = lui;
  assign ExtOp[0] = lw | sw | addi | addiu | lb | sb;
  assign RegWrite = ((addu | subu | ori | lui | addi | slt | addiu)&s7) | ((lw | lb)&s4) | (jal & s9) | (bltzal & s8);
  assign ALUSrc = ori | lui | addi | addiu | sw | lw | lb | sb;
  assign MemWrite = (sw | sb) & s5;
  assign write_30 = (addi == 1) ? 1:0;
  assign pcwr = s0 | ((j | jal)&s9) | ((beq&zero)&s8) | (jr & s8) | (bltzal & nCondition & s8);
  assign irwr = s0;
  assign islb = (lb==1)? 1:0;
  assign issb = (sb==1)? 1:0;
  
  

endmodule
