module npc(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout, nCondition);
  
  input rst;
  input zero;
  input nCondition;
  input [1:0] npc_sel;
  input [31:0] pcin, pc_ori,imm32;  //  pcin is gpr[rs]   pc_ori is original pc   imm32 is the current ins
  output [31:0] pcout;
  
  
  
  wire [15:0] imm;
  wire [31:0] temp, extout, j_addr;
  reg [31:0] pcnew;
  reg [31:0] pcout;
  
  
  assign imm = imm32[15:0];
  assign temp = {{16{imm[15]}}, imm};
  assign extout = temp << 2;
  assign j_addr = {pcout[31:28], imm32[25:0], 2'b00};
  
  initial
    begin
      pcout <= 32'h0000_3000;
    end
  
  always@(pcnew, rst)
  begin
    if(rst)
      begin
        pcout = 32'h0000_3000;
      end
    else
      begin
        pcout = pcnew;
      end
  end
  
  always@(*)
  begin
    case(npc_sel) //00:gpr[rs] 01:beq  10:j jal  11:jr
      2'b00: 
        begin
          pcnew = pc_ori + 4;
        end
        
      2'b01: 
        begin
          if(zero | nCondition)
            begin
              pcnew = pc_ori + extout;
            end
          else
            begin
              pcnew = pc_ori + 4;
            end
        end
        
      2'b10:
        begin
          pcnew = j_addr;
        end
        
      2'b11:
        begin
          pcnew = pcin;
        end
        
      default: pcnew = pc_ori + 4;
    endcase
  end

  
  
endmodule
