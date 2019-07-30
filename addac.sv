module addac(input logic [3:0] a, input logic sel0, sel1, clk, output logic [3:0] s, cout);

logic [3:0] na,m0out,accout,sum;

inversor inv(a, na);
mux m0(a,na,sel0,m0out);
somador4bit s4(m0out,accout,sel0,sum,cout);
mux m1(m0out,sum,sel1,s);
registrador acc(clk,s,accout);

endmodule