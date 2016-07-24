//This block performs the concatination and spliting to generate u0 and u1


module concat(u0, u1, u0_ip, u1_ip, clk);

input [31:0]u0_ip, u1_ip;
input clk;

output [47:0]u0;
reg [47:0]u0;

output [15:0]u1;
reg [15:0]u1;

always@(posedge clk)
begin			//u0 and u1 are obtained here
u0[47:16] <= u0_ip;
u0[15:0] <= u1_ip[15:0];
u1 <= u1_ip[31:16];
end

endmodule
 