module test_alu;
  
  reg [31:0] dataOut_1, dataOut_2, ext32;
  reg ALUSrc;
  reg [1:0] ALUOp;
  reg write_30;
  wire zero, overflow;
  wire [31:0] alu_res;

  alu alu1(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30);
  
  initial
  begin
    dataOut_1 = 32'h7fff_ffff;
    dataOut_2 = 32'h0000_0006;
    ext32 = 32'h0000_0004;
    ALUSrc = 0;
    ALUOp = 2'b00;
    write_30 = 0;
    #100
    ALUOp = 2'b01;
    
    #100
    ALUOp = 2'b10;
    
    #100
    ALUOp = 2'b11;
    
    #100
    ALUSrc = 0;
    ALUOp = 2'b00;
    
    #100
    ALUOp = 2'b01;
    
    #100
    ALUOp = 2'b10;
    
    #100
    ALUOp = 2'b11;
  
  end

endmodule
