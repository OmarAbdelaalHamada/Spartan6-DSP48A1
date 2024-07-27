module carry_in_MUX(OPMODE,CARRYIN,out);
parameter CARRYINSEL = "OPMODE5";
input OPMODE,CARRYIN;
output out;
generate
if(CARRYINSEL == "OPMODE5") begin
   assign out = OPMODE;
end else if(CARRYINSEL == "CARRYIN") begin
    assign out = CARRYIN;
end else begin 
    assign out = 0;
end
endgenerate
endmodule