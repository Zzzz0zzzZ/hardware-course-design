module test_npc;
  reg rst,zero;
  reg [31:0] pcin, pc_ori, imm32;
  reg [1:0] npc_sel;
  wire [31:0] pcout;
  
  npc npc1(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout);
  
  initial
  begin
    rst = 0;
    pcin = 32'h1111_1108;
    pc_ori = 32'h1111_1104;
    npc_sel = 2'b00;
    zero = 0;
    imm32 = 32'h0000_00ac;
    
    # 50 
    npc_sel = 2'b01;
    
    # 50
    zero = 1;
    
    # 50
    
    npc_sel = 2'b10;
    
    # 50
    npc_sel = 2'b11;
    
  end
endmodule
