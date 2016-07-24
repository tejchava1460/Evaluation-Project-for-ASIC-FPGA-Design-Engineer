
//Tausworthe random number generator main design

module taus_gen_matlab(reset, clk, urng_seed1, urng_seed2, urng_seed3, urng_out);
input clk, reset;
input [31:0]urng_seed1, urng_seed2, urng_seed3;
output [31:0]urng_out;

reg [31:0]s0, s1, s2, b, urng_out;

integer i, j;


always@(posedge clk or reset)
begin


if(reset)
begin
s0 = urng_seed1;
s1 = urng_seed2;
s2 = urng_seed3;
end
else
begin
b = (((s0 << 13) ^ s0) >> 19);
s0 = (((s0 & 32'hFFFFFFFE) << 12) ^ b);
b = (((s1 << 2) ^ s1) >> 25);
s1 = (((s1 & 32'hFFFFFFF8) << 4) ^ b);
b = (((s2 << 3) ^ s2) >> 11);
s2 = (((s2 & 32'hFFFFFFF0) << 17) ^ b);
urng_out = (s0 ^ s1 ^ s2);
end


end




endmodule
