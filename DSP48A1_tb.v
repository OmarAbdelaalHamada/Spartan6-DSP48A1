module DSP48A1_tb;
reg CLK,CARRYIN,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
reg [17:0]A,B,D,BCIN;
reg [7:0]OPMODE;
reg [47:0]C,PCIN;
wire CARRYOUT,CARRYOUTF;
wire [17:0]BCOUT;
wire [35:0]M;
wire [47:0]PCOUT,P;
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
DSP48A1 #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),
.PREG(PREG),.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG),.OPMODEREG(OPMODEREG),.CARRYINSEL(CARRYINSEL),.B_INPUT(B_INPUT))
DUT(.CLK(CLK),.OPMODE(OPMODE),.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.M(M),.P(P),.CARRYOUT(CARRYOUT),
.CARRYOUTF(CARRYOUTF),.BCIN(BCIN),.PCIN(PCIN),.BCOUT(BCOUT),.PCOUT(PCOUT),
.CEA(CEA),.CEB(CEB),.CEC(CEC),.CECARRYIN(CECARRYIN),.CED(CED),.CEM(CEM),.CEOPMODE(CEOPMODE),.CEP(CEP),
.RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),.RSTCARRYIN(RSTCARRYIN),.RSTD(RSTD),.RSTM(RSTM),.RSTOPMODE(RSTOPMODE),.RSTP(RSTP));

initial begin
    CLK = 1;
    forever begin
        #50 CLK = ~CLK;
    end
end
initial begin 
    RSTA =1;RSTB =1; RSTC =1;RSTCARRYIN =1;RSTD =1;RSTM =1;RSTOPMODE =1;RSTP =1;
    CEA =1;CEB =1;CEC =1;CECARRYIN =1;CED =1;CEM =1;CEOPMODE =1;CEP =1;
    A = 5;B = 76;C = 21;D = 33;BCIN = 87;PCIN = 89;CARRYIN = 0;
    OPMODE = 8'b00011101;
    #400
    if(P == 0 && CARRYOUT == 0)begin
        $display("true");
    end
    else begin 
        $display("false");
        $stop;
    end
    RSTA =0;RSTB =0; RSTC =0;RSTCARRYIN =0;RSTD =0;RSTM =0;RSTOPMODE =0;RSTP =0;
    CEA =1;CEB =1;CEC =1;CECARRYIN =1;CED =1;CEM =1;CEOPMODE =1;CEP =1;
    A = 5;B = 76;C = 21;D = 33;PCIN = 89;CARRYIN = 1;
    OPMODE = 8'b00011101;
    #400
    if(P == 566 && CARRYOUT == 0)begin
        $display("true");
    end
    else begin 
        $display("false");
        $stop;
    end
    ////
    A = 5;B = 76;C = 21;D = 86;PCIN = 89;CARRYIN = 1;
    OPMODE = 8'b01010001;
    #400
    if(P == 50 && CARRYOUT == 0)begin
        $display("true");
    end
    else begin 
        $display("false");
        $stop;
    end
    
    A = 5;B = 76;C = 100;D = 86;PCIN = 89;CARRYIN = 1;
    OPMODE = 8'b11011101;
    #400
    if(P == 50 && CARRYOUT == 0)begin
        $display("true");
    end
    else begin 
        $display("false");
        $stop;
    end
    A = 5;B = 10;C = 21;D = 33;PCIN = 89;CARRYIN = 1;
    OPMODE = 8'b00000001;
    #400
    if(P == 50 && CARRYOUT == 0)begin
        $display("true");
    end
    else begin 
        $display("false");
        $stop;
    end
    $stop;
end
endmodule