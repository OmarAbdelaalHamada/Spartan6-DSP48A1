module DSP48A1(CLK,OPMODE,A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,BCIN,PCIN,BCOUT,PCOUT,
CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP);
//parameters : 
parameter A0REG =0;
parameter A1REG =1;
parameter B0REG =0;
parameter B1REG =1;
parameter CREG =1;
parameter DREG =1;
parameter MREG =1;
parameter PREG =1;
parameter CARRYINREG =1;
parameter CARRYOUTREG =1;
parameter OPMODEREG =1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
//inputs:
input CLK,CARRYIN,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
input [17:0]A,B,D,BCIN;
input [7:0]OPMODE;
input [47:0]C,PCIN;
//outputs:
output CARRYOUT,CARRYOUTF;
output [17:0]BCOUT;
output [35:0]M;
output [47:0]PCOUT,P;
//wires :
wire carryin_in,carry_in_wire;
wire [7:0]OPMODE_wire;
wire [17:0]D_wire,A0_wire,A1_wire,B0_wire,B1_wire_in,B_wire_in,Adder_or_subtractor_out;
wire [35:0]M_wire;
wire [47:0]C_wire,DAB_wire;
wire [48:0]P_wire_in;
reg [47:0]X_wire,Z_wire;
//instantiations :
pipeline_register #(.REG(DREG))D_input(.clk(CLK),.clk_en(CED),.rst(RSTD),.in(D),.out(D_wire));
pipeline_register #(.REG(CREG),.WIDTH(48))C_input(.clk(CLK),.clk_en(CEC),.rst(RSTC),.in(C),.out(C_wire));
pipeline_register #(.REG(A0REG))A0_input(.clk(CLK),.clk_en(CEA),.rst(RSTA),.in(A),.out(A0_wire));
pipeline_register #(.REG(A1REG))A1_input(.clk(CLK),.clk_en(CEA),.rst(RSTA),.in(A0_wire),.out(A1_wire));
BCIN_MUX #(B_INPUT)BCin_MUX(.B(B),.BCIN(BCIN),.out(B_wire_in));
pipeline_register #(.REG(B0REG))B0_input(.clk(CLK),.clk_en(CEB),.rst(RSTB),.in(B_wire_in),.out(B0_wire));
assign Adder_or_subtractor_out = (OPMODE[6])?(D_wire-B0_wire):(D_wire+B0_wire);
assign B1_wire_in = (OPMODE[4])?Adder_or_subtractor_out:B0_wire;
pipeline_register #(.REG(B1REG))B1_input(.clk(CLK),.clk_en(CEB),.rst(RSTB),.in(B1_wire_in),.out(BCOUT));
pipeline_register #(.REG(OPMODEREG))OPMODE_input(.clk(CLK),.clk_en(CEOPMODE),.rst(RSTOPMODE),.in(OPMODE),.out(OPMODE_wire));
assign M_wire = A1_wire * BCOUT;
pipeline_register #(.REG(CREG),.WIDTH(36))M_input(.clk(CLK),.clk_en(CEM),.rst(RSTM),.in(M_wire),.out(M));
carry_in_MUX #(CARRYINSEL)CarryIN_MUX(.OPMODE(OPMODE[5]),.CARRYIN(CARRYIN),.out(carryin_in));
pipeline_register #(.REG(CARRYINREG),.WIDTH(1))CarryIN_input(.clk(CLK),.clk_en(CECARRYIN),.rst(RSTCARRYIN),.in(carryin_in),.out(carry_in_wire));
assign DAB_wire = {D_wire[11:0],A1_wire,BCOUT};
always @(*) begin
    case (OPMODE_wire[1:0])
        2'b00 : X_wire = 0 ;
        2'b01 : X_wire = {12'h0,M} ;
        2'b10 : X_wire = P ;
        2'b11 : X_wire = DAB_wire ;
    endcase
end
always @(*) begin
    case (OPMODE_wire[3:2])
        2'b00 : Z_wire = 0 ;
        2'b01 : Z_wire = PCIN ;
        2'b10 : Z_wire = PCOUT ;
        2'b11 : Z_wire = C_wire ;
    endcase
end
assign P_wire_in = (OPMODE_wire[7])?(Z_wire-(X_wire+carry_in_wire)):(Z_wire+X_wire+carry_in_wire);
pipeline_register #(.REG(PREG),.WIDTH(48))P_output(.clk(CLK),.clk_en(CEP),.rst(RSTP),.in(P_wire_in[47:0]),.out(P));
assign PCOUT = P;
pipeline_register #(.REG(CARRYOUTREG),.WIDTH(1))CarryOUT_input(.clk(CLK),.clk_en(CECARRYIN),.rst(RSTCARRYIN),.in(P_wire_in[48]),.out(CARRYOUT));
assign CARRYOUTF = CARRYOUT;
endmodule