module alu( A, B, ALUOp, zero, alu_res, overflow, condition_jdg);
  input [31:0] A;
  input [31:0] B;
  input [2:0] ALUOp;
  output reg zero;
  output reg [31:0] alu_res;
  output overflow;
  output condition_jdg;
  /*
  aluop
  000 +
  001 -
  010 ||
  011 slt
  100 addi
  101 bgezal
  11 res = 0
  */
  //assign zero = (A == B) ? 1'b1 : 1'b0;
  wire [32:0] tmp;
  
  assign tmp = {A[31],A} + B;
  
  assign overflow = (ALUOp == 3'b100) ? ((tmp[32] != tmp[31]) ? 1 : 0) : 0;
  assign condition_jdg = (ALUOp == 3'b101) ? (($signed(A) >= $signed(32'b0)) ? 1 : 0) : 0;
  
  always@(*)
    begin
      case(ALUOp)
        3'b000:
          begin
            //tmp = A + B;
            alu_res = A + B;
            /*
            if(tmp[32] != tmp[31])  
              begin
                overflow = 1;
                //tmp[32] = 0;
              end
            else  overflow = 0;
            //zero = 0;
            */
          end
          
        3'b001:
          begin
            alu_res = A - B;
            //overflow = 0;
            //zero = (alu_res == 32'b0) ? 1 : 0;
          end
          
        3'b010:
          begin
            alu_res = A | B;
            //overflow = 0;
            //zero = 0;
          end
        
        3'b011:
          begin
            alu_res = ($signed(A)<$signed(B))? 32'd1 : 32'd0;
          end
        
        3'b100:
          begin
            alu_res = A + B;
          end
          
        3'b101:
          begin
            alu_res = 32'h0000_0000;
          end
        default:
          begin
            //alu_res <= 32'h0000_0000;
            //overflow <= 0;
            //zero = 0;
            $display("no use sel for aluop");
          end
          
      endcase
      if(A == B)  zero =1;
      else  zero = 0;
      
    end
    
    
endmodule