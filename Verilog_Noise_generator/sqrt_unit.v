//module to compute the square root


module sqrt(e, f, clk, g0_, g1_, g0, g1, quad_, quad);
input [30:0]e; input [15:0]g0_, g1_; input [1:0]quad_;

input clk; 
output [16:0]f; reg [16:0]f; output [15:0]g0, g1; reg [15:0]g0, g1; output [1:0]quad; reg [1:0]quad;

reg [5:0]lzd_e;
reg [30:0]x_f_, x_f; 
reg [41:0]y_f1, y_f2, y_f;
reg [15:0]c_1, c_2;

integer i;




always@(posedge clk)
begin

i = 30;			// LZD of the 'e' vector
while(i>=0)
begin
if(e[i] == 1'b1)
begin
lzd_e = 30 - i;        //LZD o/p stored in lzd_e 
i = 0;
end
i = i-1;
end

if(lzd_e > 5)
lzd_e = 5;
lzd_e = 5 - lzd_e;	//updating lzd_e

x_f_ = e >> lzd_e;	//Doing right shift of 'e' 



if((x_f_[25] == 0)&&(x_f_[24] == 0))
x_f_[25] = 1;

x_f = x_f_;

				//Square root function evaluation

c_1 = 16'b0101001011101111;
c_2 = 16'b1011101111000001;

y_f1 = c_1*x_f;

y_f2[41:40] = 0;
y_f2[39:24] = c_2[15:0];
y_f2[23:0] = 0;

y_f = y_f1 + y_f2;


if(lzd_e[0] == 1)
lzd_e = lzd_e + 1;

f[16:0] = y_f[41:25];
f = f << lzd_e; 



g0 = g0_;
g1 = g1_;
quad = quad_;

end
endmodule 












