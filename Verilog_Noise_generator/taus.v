//this module gives the random numbers as output


module taus(reset, clk, urng1, urng2, urng3, urng_out);
input clk, reset;
input [31:0]urng1, urng2, urng3;
output [31:0]urng_out;

reg [31:0]s0, s1, s2, b, urng_out;
reg start;
integer i, j;


always@(posedge clk or reset)
begin


if(reset)
start = 1;


if(start)
begin              // initialization of the input seeds
s0 = urng1;
s1 = urng2;
s2 = urng3;
start = 0;
end

else
begin		//This part of code is taken from the given IEEE paper
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
