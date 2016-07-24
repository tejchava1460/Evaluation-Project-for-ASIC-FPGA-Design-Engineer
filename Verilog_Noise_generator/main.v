//This is Main Controller block Which connects all the other blocks


module main_ctlr(clk, reset, urng_seed1, urng_seed2, urng_seed3, urng_seed4, urng_seed5, urng_seed6, awgn_out_0, awgn_out_1);


input clk, reset;
input [31:0]urng_seed1, urng_seed2, urng_seed3, urng_seed4, urng_seed5, urng_seed6;

output [15:0]awgn_out_0, awgn_out_1;


wire [31:0]urng_o_1, urng_o_2;
wire [47:0]u0;
wire [15:0]u1, g0_, g1_, g0, g1;
wire [30:0]e;
wire [16:0]f;
wire [1:0]quad_, quad;


//taus module generates the random numbers based on the selected seed in the 'top_level_tb.sv' file

taus taus_1(.clk(clk), .reset(reset), .urng1(urng_seed1), .urng2(urng_seed2), .urng3(urng_seed3), .urng_out(urng_o_1));
taus taus_2(.clk(clk), .reset(reset), .urng1(urng_seed4), .urng2(urng_seed5), .urng3(urng_seed6), .urng_out(urng_o_2));

//concat module performs the concatination of the input random numbers

concat concatn(.clk(clk), .u0(u0), .u1(u1), .u0_ip(urng_o_1), .u1_ip(urng_o_2));

//log module is for logarithm analysis

log ln(.clk(clk), .u0(u0), .e(e));

//sin_cos module is for the trigeonometric function analysis

sin_cos s_c(.clk(clk), .u1(u1), .g0(g0_), .g1(g1_), .quad(quad_));

//sqrt module is for the square root function analysis

sqrt sq(.clk(clk), .e(e), .f(f), .g0_(g0_), .g1_(g1_), .g0(g0), .g1(g1), .quad_(quad_), .quad(quad));

//mul_cal block calculates the final product g0*f, g1*f

mul_cal m_c(.clk(clk), .f(f), .g0(g0), .g1(g1), .x0(awgn_out_0), .x1(awgn_out_1), .quad(quad));


endmodule
