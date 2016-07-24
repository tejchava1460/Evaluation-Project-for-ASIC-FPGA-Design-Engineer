//trigeonometric function evaluation module


module sin_cos(u1, g0, g1, clk, quad);
input [15:0]u1; input clk;

output [15:0]g0, g1; output [1:0]quad;
reg [15:0]g0, g1;
reg [1:0]quad;
reg [13:0]x_g_a, x_g_b, g_b;
reg [16:0]c_1, c_2, y_a, y_b, y_g_a, y_g_b;
reg [30:0]y_g_1, y_g_2; 

integer i;




always@(posedge clk)
begin
quad[1:0] = u1[15:14];   //obtaining quad from u1


x_g_a = u1[13:0];
			
g_b = 14'b11111111111111;  // 1-2^(-14)   in binary
x_g_b = g_b - x_g_a;

				//Trigeonometric function approximation
c_1 = 17'b10100010010001110;
c_2 = 17'b10100010001100100;

y_g_1 = c_1 * x_g_a;
y_g_2 = c_1 * x_g_b;



y_a[16:0] = y_g_1[30:14];
y_b[16:0] = y_g_2[30:14];



y_g_a = - y_a + c_2;
y_g_b = - y_b + c_2;

if(y_a > c_2) begin
y_g_a = -y_g_a;
quad[1:0] = 0;
end

if(y_b > c_2) begin
y_g_b = -y_g_b;
quad[1:0] = 0;
end
g0[15:0] = y_g_b[16:1]; g1[15:0] = y_g_a[16:1];


end

endmodule
