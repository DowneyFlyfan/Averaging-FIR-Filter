`timescale 1ns / 100ps

module fir4csa #(
    parameter w = 16
) (
    input                clk,
    input                rst_n,
    input        [w-1:0] a,
    output logic [w+1:0] s
);

  logic [w-1:0] ar, br, cr, dr;
  // CSA
  logic [w-1:0] csa4_s;
  logic [w : 0] csa4_c;
  logic [w : 0] csa5_s;
  logic [w+1:0] csa5_c;
  logic [w+1:0] sum;
  logic [w+1:0] p;
  logic [w+1:0] g;
  logic [w+1:0] c;

  // CLA
  CLA #(
      .w(w + 2)
  ) cla (
      .ain({1'b0, csa5_s}),
      .bin(csa5_c),
      .cin(0),
      .sum(sum)
  );

  always_comb begin
    csa4_c[0] = 0;  // carry runs from [w:1], not [w-1:0]
    csa5_c[0] = 0;
    for (int i = 0; i < w; i++) {csa4_c[i+1], csa4_s[i]} = ar[i] + br[i] + cr[i];
    for (int i = 0; i < w + 1; i++) {csa5_c[i+1], csa5_s[i]} = csa4_c[i] + csa4_s[i] + dr[i];

    // TODO: WHY?
    csa5_s[w]   = csa4_c[w];  // don't even need top FA
    csa5_c[w+1] = 0;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      ar <= 'b0;
      br <= 'b0;
      cr <= 'b0;
      dr <= 'b0;
      s  <= 'b0;
    end else begin
      ar <= a;
      br <= ar;
      cr <= br;
      dr <= cr;
      s  <= sum;
    end
  end

endmodule
