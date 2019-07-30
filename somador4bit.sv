module somador4bit(input logic [3:0] a, b, input logic cin, output logic [3:0] s, cout);


somador1bit s0 (a[0],b[0],cin,s[0],cout[0]);
somador1bit s1 (a[1],b[1],cout[0],s[1],cout[1]);
somador1bit s2 (a[2],b[2],cout[1],s[2],cout[2]);
somador1bit s3 (a[3],b[3],cout[2],s[3],cout[3]);

endmodule