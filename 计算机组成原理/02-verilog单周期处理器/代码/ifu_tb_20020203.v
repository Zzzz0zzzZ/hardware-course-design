module test_ifu;
  reg clk, reset, npc_sel, zero, j;
  wire [15:0] imm16;
  wire [31:0] insout;
  wire [5:0] opcode;
  wire [5:0] funct;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  
ifu it1(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16);
    
  initial
  begin
    clk = 1;
    reset = 0;
    npc_sel = 0;
    zero = 0;
    j = 0;
    #5 reset = 1;
    #5 reset = 0;
    
    //$readmemh("code.txt", it1.im);
    //#30 npc_sel = 1; zero = 1;
    //#30 npc_sel = 0; zero = 0;
    
    
  end
  
  always
   #30 clk = ~clk;
   
endmodule
 
  



