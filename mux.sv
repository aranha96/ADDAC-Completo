module mux(input logic [3:0] d0, d1, input logic s, output tri [3:0] y);

not inversor(ns, s);

tristate t0(d0, ns, y);
tristate t1(d1, s, y);
endmodule
