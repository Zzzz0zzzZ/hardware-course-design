module test_mux_2c1;
  reg sel;
  reg [31:0] din_0;
  reg [31:0] din_1;
  wire [31:0] dout;
  
  mux_2c1_32bit mux_1(sel, din_0, din_1, dout);
  
  initial
    begin
      sel = 0;
      din_0 = 32'h1234_5678;
      din_1 = 32'h8765_4321;
      
      # 30 
      sel = 1;
      
      # 30
      sel = 0;
    end
  
endmodule

module test_mux_3c1;
    
    reg [1:0] sel;
    reg [4:0] din_0;
    reg [4:0] din_1;
    reg [4:0] din_2;
    wire [4:0] dout;
    
    mux_3c1_5bit mux_2(sel, din_0, din_1, din_2, dout);
    
    initial
      begin
        din_0 = 5'b00000;
        din_1 = 5'b00001;
        din_2 = 5'b00010;
        sel = 2'b00;
        #30
        sel = 2'b01;
        #30
        sel = 2'b10;
        #30
        sel = 2'b11;
      end


endmodule
