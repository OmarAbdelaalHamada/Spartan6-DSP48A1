module BCIN_MUX(B,BCIN,out);
parameter B_INPUT = "DIRECT";
input B,BCIN;
output out;
generate
if(B_INPUT == "DIRECT") begin
   assign out = B;
end else if(B_INPUT == "CASCADE") begin
    assign out = BCIN;
end else begin 
    assign out = 0;
end
endgenerate
endmodule