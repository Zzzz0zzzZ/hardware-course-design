module test_gpr;
  reg clk, rst, gprwr, write_30, overflow;
  reg [1:0] MemToReg, RegDst;
  reg [4:0] rs, rt, rd;
  reg [31:0] pc_p4, aluReg_out, dmReg_out;
  
  gpr gpr1(clk, rst, gprwr, MemToReg, RegDst, rs, rt, rd, write_30, pc_p4, aluReg_out, dmReg_out, overflow, dataOut_1, dataOut_2);

  initial
  begin
    clk = 0;
    rst = 0;
    gprwr = 0;
    MemToReg = 2'b00;
    RegDst = 2'b00;
    rs = 5'd0;
    rt = 5'd6;
    rd = 5'd7;
    aluReg_out = 32'h1234_5678;
    dmReg_out = 32'h 1111_1111;
    pc_p4 = 32'h2222_2222;
    write_30 = 0;
    overflow = 0;
    
    # 100
    gprwr = 1;
    # 100
    gprwr = 0;
    #100
    gprwr = 1;
    RegDst = 2'b10;
    MemToReg = 2'b10;
    #100
    gprwr = 0;
    #100
    gprwr = 1;
    overflow = 1;
    #100
    write_30 = 1;
    # 200
    rst = 1;
    # 100
    rst = 0;
    
  end
  
  always
    # 50 clk = ~clk;
endmodule