//This is the Test bench to test the Noise_generator

//Interface is named as 'ng_in'    ---->   38 to 60

//trans and trans_m_s are the two type of transactions

//tran ====>   64 to 69
      //communication b/w driver and the generator using mailbox named as 'g_d'

//trans_m_s =====>  71 to 75
      //communication b/w monitor and scoreboard using mailbox named as 'm_s'


//Generator ----->  80 to 112

             // **************** In this block  the seed values are changed   102 to 107

//Driver  ------>  117 to 150



//Monitor ------>   155 to 188


//Scoreboard ------->  193 t0 299

	    //  ************* In this block the MATLAB output file is read
	    //  ************* Names  should be 'x0.txt', 'x1.txt'	
	    //  ****** Three ouput files are generated 1) awgn_out.txt  2) checker.log_0.txt 3) checker.log_1.txt
       // ****** checker.log_.txt is file contains comparison results b/w verilog and MATLAB outputs

//Top_level_module------>  310 to 351

		


//Interface
interface ng_in(input clk);

logic reset;
logic [31:0]urng_seed1, urng_seed2, urng_seed3, urng_seed4, urng_seed5, urng_seed6;
logic [15:0]awgn_out_0, awgn_out_1;

clocking driver @(posedge clk);
default input #2ns output #2ns;

output reset, urng_seed1, urng_seed2, urng_seed3, urng_seed4, urng_seed5, urng_seed6;
endclocking

clocking monitor @(posedge clk);
default input #2ns output #2ns;

input awgn_out_0, awgn_out_1;
endclocking

modport driver_(clocking driver);
modport monitor_(clocking monitor);
modport scr_brd(input clk);

endinterface


//trans transaction
class trans;

bit rst;
logic [31:0]seed1, seed2, seed3, seed4, seed5, seed6;

endclass

class trans_m_s;

logic [15:0]awgn_out_0, awgn_out_1;

endclass



//Generator 
class generator;

trans tr = new;

mailbox g_d;

function new(mailbox g_d);
this.g_d = g_d;
endfunction

int i =2;

virtual task run();

if (i)
begin
tr.rst = 1;
i = i-1;
end
else
tr.rst = 0;
			//Do change the seed values for the MATLAB code also
tr.seed1 = 29;
tr.seed2 = 43;
tr.seed3 = 113;
tr.seed4 = 17;
tr.seed5 = 91;
tr.seed6 = 79;

g_d.put(tr);

endtask
endclass



//Driver
class drivr;

virtual ng_in.driver dri;
mailbox g_d;


function new(virtual ng_in.driver dri, mailbox g_d);
this.dri = dri;
this.g_d = g_d;
endfunction


trans tr = new;

virtual task run;

@(posedge dri.clk)
begin
g_d.get(tr);


dri.reset = tr.rst;
dri.urng_seed1 = tr.seed1;
dri.urng_seed2 = tr.seed2;
dri.urng_seed3 = tr.seed3;
dri.urng_seed4 = tr.seed4;
dri.urng_seed5 = tr.seed5;
dri.urng_seed6 = tr.seed6;

end

endtask

endclass



//Monitor
class monitr;

virtual ng_in.monitor mon;
logic [15:0]test;
mailbox m_s;
trans_m_s tr = new;


function new(virtual ng_in.monitor mon, mailbox m_s);
this.mon = mon;
this.m_s = m_s;
endfunction

integer i;
virtual function void file();
i = $fopen("awgn_out.txt", "w");
$fwrite(i, " awgn_out_0           awgn_out_1 \n");
endfunction

virtual task run;

@(posedge mon.clk)
begin
test = mon.awgn_out_0 ^ mon.awgn_out_0 ;
if(test == 0)
$fwrite(i, "%b  %b \n", mon.awgn_out_0, mon.awgn_out_1);
tr.awgn_out_0 = mon.awgn_out_0;
tr.awgn_out_1 = mon.awgn_out_1;
m_s.put(tr);
end
endtask


endclass



//Scoreboard
class scoreboard;

mailbox m_s;
trans_m_s tr = new;

virtual ng_in.scr_brd s_b;

integer i, j, i1, j1, k, l, m;
shortreal value1, value2,v;
logic [15:0]x0, x1, test;

function new(mailbox m_s, virtual ng_in.scr_brd s_b);
this.m_s = m_s;
this.s_b = s_b;
k = 1;
endfunction

extern task float_compute(logic [15:0]x, logic [15:0]awgn); //Calculates the float value for the final o/p

virtual function void file();
i = $fopen("x0.txt", "r");       // Output files of MATLAB
j = $fopen("x1.txt", "r");
l = $fopen("checker_log_0.txt", "w");   // Output files of Verilog
m = $fopen("checker_log_1.txt", "w");
endfunction

virtual task run;

@(posedge s_b.clk)
begin
m_s.get(tr);
value1 = 0;
value2 = 0;
test = tr.awgn_out_0 ^ tr.awgn_out_0;
					//Running Comparisons b/w the two inputs
if(test == 0)
begin
i1 = $fscanf(i, "%b \n", x0[15:0]);
j1 = $fscanf(j, "%b \n", x1[15:0]);

if(x0[15:0] ^ tr.awgn_out_0[15:0]) begin
float_compute(x0, tr.awgn_out_0);
$fwrite(l, "Sample %d awgn_out_0 isn't matched  =>    \n", k);
$fwrite(l, "                                         Matlab   awgn_out_0  is     %b      %f\n", x0[15:0], value1);
$fwrite(l, "                                        Verilog   awgn_out_0  is     %b      %f\n", tr.awgn_out_0[15:0], value2);
end
else
$fwrite(l, "Sample %d awgn_out_0 is matched  ;    \n", k);
if(x1[15:0] ^ tr.awgn_out_1[15:0]) begin
float_compute(x1, tr.awgn_out_1);
$fwrite(m, "Sample %d awgn_out_1 isn't matched  =>    \n", k);
$fwrite(m, "                                         Matlab   awgn_out_1  is     %b      %f\n", x1[15:0], value1);
$fwrite(m, "                                        Verilog   awgn_out_1  is     %b      %f\n", tr.awgn_out_1[15:0], value2);
end
else
$fwrite(m, "Sample %d awgn_out_1 is matched  ;    \n", k);

k = k+1;
tr.awgn_out_0 = 16'hXXXX;
tr.awgn_out_1 = 16'hXXXX;
end
if(k == 10001)
$finish;

end
endtask

endclass



task scoreboard::float_compute(logic [15:0]x, logic [15:0]awgn);
int c;
value1 = 0;
value2 = 0;

if(x[15])
begin
x = -x;
awgn = -awgn;
c = 4;
while(c >= -11)
begin
if(c<0)
v = 0.00048828125*2048/(2**(-c));
else
v = 2**c;
value1 = value1 + x[11+c]*v;
value2 = value2 + awgn[11+c]*v;
c = c-1;
end
value1 = -value1;
value2 = -value2;
end
else
begin
c = 4;
while(c >= -11)
begin
value1 = value1 + x[11+c]*(2**(c));
value2 = value2 + awgn[11+c]*(2**(c));
c = c-1;
end
end


endtask





//Top_level Test_bench module connects Every this

//This is the module to be simulated


module top_level_test;

bit clk,m;

always #50ns clk = ~clk;

ng_in f_i_0(clk);

main_ctlr s_f(.reset(f_i_0.reset), .clk(clk), .urng_seed1(f_i_0.urng_seed1), .urng_seed2(f_i_0.urng_seed2), .urng_seed3(f_i_0.urng_seed3), .urng_seed4(f_i_0.urng_seed4), .urng_seed5(f_i_0.urng_seed5), .urng_seed6(f_i_0.urng_seed6), .awgn_out_0(f_i_0.awgn_out_0), .awgn_out_1(f_i_0.awgn_out_1));


initial
begin

mailbox g_d = new;
mailbox m_s = new;
generator g1 = new(g_d);
drivr d1 = new(f_i_0.driver_, g_d);
monitr m1 = new(f_i_0.monitor_, m_s);
scoreboard s1 = new(m_s, f_i_0.scr_brd);
m = 1;



wait(m);

m1.file();
s1.file();

while(m)
fork
g1.run();
d1.run();
m1.run();
s1.run();
join




end
endmodule










