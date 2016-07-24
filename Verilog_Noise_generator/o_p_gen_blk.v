//This is the final output block 


module mul_cal(g0, g1, x0, x1, f, clk, quad);
input [15:0]g0, g1; input clk; input [16:0]f; input [1:0]quad;

output [15:0]x0, x1;
reg [15:0]x0, x1, x; reg [32:0]x0_, x1_;




always@(posedge clk)
begin

x0_ = g0*f;  //Product Calculation
x1_ = g1*f;

x0[15:0] = x0_[32:17];
x1[15:0] = x1_[32:17];

			//Based on the quad value changing the sign of the final output
if(quad == 2'b00) begin
    x0 = x0; x1 = x1; end
  
if(quad == 2'b01) begin
x = x0;
    x0 = x1; x1 = -x; end

if(quad == 2'b10) begin
    x0 = -x0; x1 = -x1; end

if(quad == 2'b11) begin
x = x0;
    x0 = -x1; x1 = x; end



end

endmodule 