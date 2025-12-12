`timescale 1ns / 100ps
module project_tb2_u;
  parameter w = 16;  // operand bit width
  parameter period = 5;

  logic clk = 'b0, rst_n = 'b1;
  logic [w-1:0] a;
  wire  [w+1:0] s;
  wire  [w+2:0] diff;
  logic [w+1:0] s_real;
  logic [w-1:0] ar, br, cr, dr;

  fir4csa #(.w(w)) f1 (.*);

  initial begin : clock_gen
    clk = 0;
    forever #(period / 2) clk = ~clk;
  end

  initial begin : simulation
    $display("a  s  s_b  diff");

    begin : reset
      rst_n = 1'b0;
      @(negedge clk);
      rst_n = 1'b1;
    end

    for (int i = 0; i < 25; i++) begin : number_gen
      // a = $random;
      a = $urandom_range('hFFFF_FFFF, 1);  // Unsigned Number
      #(period * 0.8) $displayh(a,,,,, s,,,, s_real,,,, diff);
      #(period * 0.2);
    end
    #(5 * period) $stop;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin : rst
      ar <= 'b0;
      br <= 'b0;
      cr <= 'b0;
      dr <= 'b0;
      s_real <= 'b0;
    end : rst
    else begin : run
      ar <= a;
      br <= ar;
      cr <= br;
      dr <= cr;
      s_real <= ar + br + cr + dr;
    end
  end

  assign diff = s - s_real;
endmodule
