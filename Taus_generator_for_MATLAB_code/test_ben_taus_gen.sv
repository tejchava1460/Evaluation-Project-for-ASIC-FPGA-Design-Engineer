//Test_bench for the tausworth random number genrator

module test_ben_taus_genr;


reg reset, clk;
reg [31:0]seed1, seed2, seed3, seed4, seed5, seed6;

reg [31:0]test;
wire [31:0]rand_1, rand_2;

integer i,j,k;


taus_gen_matlab t_g_0(.reset(reset), .clk(clk), .urng_seed1(seed1), .urng_seed2(seed2), .urng_seed3(seed3), .urng_out(rand_1));
taus_gen_matlab t_g_1(.reset(reset), .clk(clk), .urng_seed1(seed4), .urng_seed2(seed5), .urng_seed3(seed6), .urng_out(rand_2));

initial
begin

//Change the seed to verify for different values

seed1 = 29 ;
seed2 = 43 ;
seed3 = 113 ;
seed4 = 17 ;
seed5 = 91 ;
seed6 = 79 ;
reset = 1;
clk = 0;
k = 0;

//Random numbers are stored in the following files
//Later copy these files and use as input for the MATLAB code

i = $fopen("rand_1.txt", "w");
j = $fopen("rand_2.txt", "w");
end

always
begin
#10 clk = ~clk;
end

always@(posedge clk)
begin
test = rand_1 ^ rand_1;
if(test == 0)
begin
$fwrite(i, "%d \n", rand_1);
$fwrite(j, "%d \n", rand_2);
k = k+1;
end

if(k == 10000)
$finish;
reset = 0;

end
endmodule 