//Logarithm function evaluation


module log(u0, e, clk);
input [47:0]u0;

input clk;

output [30:0]e;

reg [30:0]e;
reg [7:0]exp_e;
reg [47:0]x_e;
reg [113:0]y_e1, y_e_2, y_e_3, y_e;
reg [65:0]y_e2;
reg [15:0]ln2;
reg [18:0]e_e;
reg [33:0]e_e_, y_e_; 
reg [34:0]e0;
reg [16:0]c_e_1;
reg [16:0]c_e_2, c_e_3;
reg [48:0]x_e_;

integer i;

always@(posedge clk)
begin
i = 47;			//Leading zero calculation for u0
while(i>=0)
begin
if(u0[i] == 1'b1)
begin
exp_e = 48 - i;		//exp_e has the LZD value
i = 0;
end
i = i-1;
end

x_e = x_e&(48'h000000000000);

x_e = u0 << exp_e;	//Left shift of u0 based on exp_e	


y_e = 0;
			//Logarithm function Approximation
c_e_1 = 17'b00011011000001110;
c_e_2 = 17'b10101000111110001;
c_e_3 = 17'b10001101010001101;

x_e_[47:0] = x_e[47:0];
x_e_[48] = 1;

y_e1 = c_e_1*x_e_*x_e_ ;
y_e2 = c_e_2*x_e_ ;



y_e_3[113] = 0;
y_e_2[113:48] = y_e2[65:0];
y_e_2[47:0] = 0;
y_e_3[112:96] = c_e_3[16:0];
y_e_3[95:0] = 0;

y_e = -y_e1 + y_e_2 - y_e_3; // Evalulating the polynomial 



ln2 = 16'b1011000101110010;
e_e = exp_e*ln2;

y_e_[33:31] = 0;
y_e_[30:0] = y_e[111:81];

e_e_[33:15] = e_e[18:0];
e_e_[14:0] = 0;
e0 = e_e_ + y_e_;


e[27:0] = e0[34:7];
e[30:28] = 0;



end
endmodule
