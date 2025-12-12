`timescale 1ns / 100ps
module Valency_4_Adder (
    input [3:0] ain,
    input [3:0] bin,
    input cin,
    output logic [3:0] sum,
    output logic cout
);

  logic [3:0] G, P, C;

  assign P = ain ^ bin;
  assign G = ain & bin;

  assign C[0] = cin;
  assign C[1] = (G[0] | (C[0] & P[0]));
  assign C[2] = (G[1] | (G[0] & P[1]) | (C[0] & P[1] & P[0]));
  assign C[3] = (G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[2] & P[1] & P[0]));

  assign sum = P ^ C;
  assign cout= (G[3] | (G[2]&P[3]) | (G[1]&P[2]&P[3]) | 
                  (G[0]&P[1]&P[2]&P[3]) | (C[0]&P[0]&P[1]&P[2]&P[3]));
endmodule

module Valency_5_Adder (
    input [4:0] ain,
    input [4:0] bin,
    input cin,
    output logic [4:0] sum,
    output logic cout
);

  logic [4:0] G, P, C;

  assign P = ain ^ bin;
  assign G = ain & bin;

  assign C[0] = cin;
  assign C[1] = (G[0] | (C[0] & P[0]));
  assign C[2] = (G[1] | (G[0] & P[1]) | (C[0] & P[1] & P[0]));
  assign C[3] = (G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[2] & P[1] & P[0]));
  assign C[4]= (G[3] | (G[2]&P[3]) | (G[1]&P[2]&P[3]) |
                  (G[0]&P[1]&P[2]&P[3]) | (C[0]&P[0]&P[1]&P[2]&P[3]));

  assign sum = P ^ C;
  assign cout= (G[4] | (G[3]&P[4]) | (G[2]&P[3]&P[4]) |
                  (G[1]&P[2]&P[3]&P[4]) | (G[0]&P[1]&P[2]&P[3]&P[4]) |
                  (C[0]&P[0]&P[1]&P[2]&P[3]&P[4]));
endmodule

module Valency_6_Adder (
    input [6:0] ain,
    input [6:0] bin,
    input cin,
    output logic [6:0] sum,
    output logic cout
);

  logic [6:0] G, P, C;

  assign P = ain ^ bin;
  assign G = ain & bin;

  assign C[0] = cin;
  assign C[1] = (G[0] | (C[0] & P[0]));
  assign C[2] = (G[1] | (G[0] & P[1]) | (C[0] & P[1] & P[0]));
  assign C[3] = (G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[2] & P[1] & P[0]));
  assign C[4]= (G[3] | (G[2]&P[3]) | (G[1]&P[2]&P[3]) |
                  (G[0]&P[1]&P[2]&P[3]) | (C[0]&P[0]&P[1]&P[2]&P[3]));
  assign C[5]= (G[4] | (G[3]&P[4]) | (G[2]&P[3]&P[4]) |
                  (G[1]&P[2]&P[3]&P[4]) | (G[0]&P[1]&P[2]&P[3]&P[4]) |
                  (C[0]&P[0]&P[1]&P[2]&P[3]&P[4]));

  assign sum = P ^ C;
  assign cout= (G[5] | (G[4]&P[5]) | (G[3]&P[4]&P[5]) |
                  (G[2]&P[3]&P[4]&P[5]) | (G[1]&P[2]&P[3]&P[4]&P[5]) |
                  (G[0]&P[1]&P[2]&P[3]&P[4]&P[5]) | (C[0]&P[0]&P[1]&P[2]&P[3]&P[4]&P[5]));
endmodule

module CLA #(
    parameter w = 18
) (
    input logic [w- 1 : 0] ain,
    input logic [w-1:0] bin,
    input logic cin,

    output logic [w-1:0] sum,
    output logic cout
);
  logic c4, c8, c12, c18;
  assign cout = c18;

  // instantiating the 16 bit CLA
  Valency_4_Adder uut1 (
      .ain (ain[3:0]),
      .bin (bin[3:0]),
      .cin (cin),
      .sum (sum[3:0]),
      .cout(c4)
  );

  Valency_4_Adder uut2 (
      .ain (ain[7:4]),
      .bin (bin[7:4]),
      .cin (c4),
      .sum (sum[7:4]),
      .cout(c8)
  );

  Valency_4_Adder uut3 (
      .ain (ain[11:8]),
      .bin (bin[11:8]),
      .cin (c8),
      .sum (sum[11:8]),
      .cout(c12)
  );

  Valency_6_Adder uut4 (
      .ain (ain[17:12]),
      .bin (bin[17:12]),
      .cin (c12),
      .sum (sum[17:12]),
      .cout(c18)
  );

endmodule
