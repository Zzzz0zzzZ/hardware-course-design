module test_alu;
  reg [31:0] A;
  reg [31:0] B;
  reg [2:0] ALUOp;
  wire zero;
  wire [31:0] alu_res;
  wire overflow;
  
  alu alu_1( A, B, ALUOp, zero, alu_res, overflow);
  
  initial
    begin
      A = 32'hffff_ffff;
      B = 32'h0000_0001;
      ALUOp = 3'b001;
      
      # 40
      ALUOp = 3'b000;
      
      # 40
      A = 32'h0000_0003;
      B = 32'hffff_1114;
      ALUOp = 3'b000;
      
      # 40
      A = 32'h0000_0003;
      B = 32'h0000_0004;
      ALUOp = 3'b000;
      
      
      # 40
      ALUOp = 3'b011;
      
      # 40
      A = 32'h0000_0005;
      
      
    end
  /*  
  always
    begin
    # 20
    B = B + 32'h0000_0001;
    A = A + 32'h0000_0011;
    end
  */
endmodule

