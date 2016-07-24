clc;
clear all;
close all;

% rand_1.txt and ran_2.txt should be obtained from verilog tausworthe
% generator

M = dlmread('rand_1.txt');
N = dlmread('rand_2.txt');


M = uint32(M);
N = uint32(N);
M = dec2bin(M);  % converting from decimal to binary
N = dec2bin(N);

% Concatination Part
u = M;
u0 = horzcat(u, N(:, 17:32));
u1 = N(1:10000, 1:16);

% LZD for u0
exp_e = zeros(10000, 1);
[row col] = size(u0);
 
k = 1; 

    while k <= 10000
        j = 1;
        
        while j <= col
    
    if (bin2dec(u0(k, j)) == 1)
        exp_e(k, 1) = j - 1;
        
        k = k+1;
        j = col+1;
    else
    j =j+1;
    end
    
    end
    end

  exp_e = exp_e + 1;


for j = 1:10000
for i = 1:48
u0(j, i) = bin2dec(u0(j, i));
end
end

x_e = zeros(10000, 48);

% Doing the left shift for the output of LZD = exp_e, on x_e_1
for d = 1:10000
    t = exp_e(d, 1);
   
x_e(d, 1:48) = horzcat(u0(d, (t+1):48), zeros(1, t));
   
    end
% Functional approximation for the logarithm

for j = 1:10000
    x_e_1(j, 1) = 1;
for i = 1:48
x_e_1(j, 1) = x_e_1(j, 1) + (2^(-i))*x_e(j, i);
end

y_e(j, 1) = (0.211151*x_e_1(j, 1)*x_e_1(j, 1) - 1.320084*x_e_1(j, 1) + 1.103714) ;

end

ln2 = 0.693146;
e_e = exp_e*ln2;
e0 = e_e - y_e; % Updating y_e

% e0 is a fractional number converting it into binary

n = 7;         % number bits for integer part of your number      
m = 24;         % number bits for fraction part of your number
% binary number
e = fix(rem(e0(1:10000, 1)*pow2(-(n-1):m),2));

exp_f = zeros(10000, 1);

[row col] = size(e);
 %LZD for the 'e' obtained above
k = 1; 

    while k <= 10000
        j = 1;
        
        while j <= col
    
    if ((e(k, j)) == 1)
        exp_f(k, 1) = j - 1;
        
        k = k+1;
        j = col+1;
    else
    j =j+1;
    end
    
    end
    end
%Adjusting the LZD output 
for i = 1:10000
    if (exp_f(i, 1) > 5)
        exp_f(i, 1) = 5;
    end  
    
    end
exp_f = 5 - exp_f;    
%Doing right shift for the output of LZD = exp_f, on e
for d = 1:10000
    t = exp_f(d, 1);
   
x_f_(d, 1:31) = horzcat(zeros(1, t), e(d, 1:(31-t)));
   
    end

for i = 1:10000
    if ((x_f_(i , 6) == 0)&&(x_f_(i , 7) == 0))
        x_f_(i, 6) = 1;
    end
end
x_f = x_f_;
% Functional Approximation for the square root unit
for j = 1:10000
    x_f_1(j, 1) = x_f(j, 6)*2 + x_f(j, 7);
for i = 8:31
x_f_1(j, 1) = x_f_1(j, 1) + (2^(-(i-7)))*x_f(j, i);    
end
y_f(j, 1) = 0.323959*x_f_1(j, 1) + 0.733414;

end

%Converting the above floating point into the binary

n = 2;         % number bits for integer part of your number      
m = 15;         % number bits for fraction part of your number
% binary number
y_f_ = fix(rem(y_f(1:10000, 1)*pow2(-(n-1):m),2));

exp_f_ = dec2bin(exp_f);

for i = 1:10000
    if(bin2dec(exp_f_(i, 2)) == 1)
        exp_f(i, 1) = exp_f(i, 1) + 1;
    end
end

exp_f = dec2bin(exp_f);

%Right shift of exp_f

for d = 1:10000

exp_f(d, 1:3) = horzcat(zeros(1, 1), exp_f(d, 1:2));
   
    end

exp_f = bin2dec(exp_f);


%Left shift of y_f and getting 'f'

for d = 1:10000
    t = exp_f(d, 1);
   
f(d, 1:17) = horzcat(y_f_(d, (t+1):17), zeros(1, t));
   
end

% Converting 'f' from binary to a floating point 
    
n = 4;
m = 13;

f_ = f*pow2(n-1:-1:-m).' ;

%Operations on u1

for j = 1:10000
for i = 1:16
u1(j, i) = bin2dec(u1(j, i));
end
end

%Obtaining the quad values
for j = 1:10000
quad(j, 1) = u1(j, 1);
quad(j, 2) = u1(j, 2);
end


u11(:, 1:14) = u1(:, 3:16);
% u1 from binary to floating point
for i = 1:10000
    u1_(i, 1) = 0;
    for j = 1:14
        u1_(i, 1) = u1_(i, 1) + (2^((-1)*j))*u11(i, j) ;
    end
end

x_g_a = u1_;

x_g_b = 0.999939 - u1_;
%Function Approximation for the trigeometric function
for i = 1:10000
y_g_a(i, 1) = -1.267792*x_g_a(i, 1)+ 1.267151;

if y_g_a(i, 1) < 0.0
    y_g_a(i, 1) = y_g_a(i, 1)*(-1);
    quad(i, 1:2) = 0;
end

y_g_b(i, 1) = -1.267792*x_g_b(i, 1) + 1.267151;

if y_g_b(i, 1) < 0.0
    y_g_b(i, 1) = y_g_b(i, 1)*(-1);
    quad(i, 1:2) = 0;
end

end

% Based on quad changing g0 and g1 sign

for i = 1:10000
if((quad(i, 1) == 0)&&(quad(i, 2) == 0))
    g0(i,1) = y_g_b(i, 1); 
    g1(i,1) = y_g_a(i, 1);
  
end
if((quad(i, 1) == 0)&&(quad(i, 2) == 1))
    g0(i,1) = y_g_a(i, 1); 
    g1(i,1) = (-1)*y_g_b(i, 1);
    
end
if((quad(i, 1) == 1)&&(quad(i, 2) == 0))
    g0(i,1) = (-1)*y_g_b(i, 1); 
    g1(i,1) = (-1)*y_g_a(i, 1);
    
end
if((quad(i, 1) == 1)&&(quad(i, 2) == 1))
    g0(i,1) = -y_g_a(i, 1); 
    g1(i,1) = y_g_b(i, 1);
   
end
%Final product calculation
x0(i, 1) = f_(i, 1)*g0(i, 1);
x1(i, 1) = f_(i, 1)*g1(i, 1);

end

% CDF plotting

[f,x_values] = ecdf(x0);
J = plot(x_values,f);
hold on;
K = plot(x_values,normcdf(x_values),'r--');
set(J,'LineWidth',2);
set(K,'LineWidth',2);
legend([J K],'Empirical CDF of awgn-out-0','Standard Normal CDF','Location','SE');



x0_0 = zeros(10000, 16);
x1_1 = zeros(10000, 16);

% x0 ===>  Converting into binary and doing 2's complement

for j = 1:10000

n = 5;         % number bits for integer part of your number      
m = 11;         % number bits for fraction part of your number
    
y = x0(j, 1);

if y < 0.0
    xx = -y;         
x00 = fix(rem(xx(1, 1)*pow2(-(n-1):m),2));
i = 16; dne = 1;
while (i >= 1)
    
        if (dne == 0)
        if(x00(1, i) == 1)
            x00(1, i) = 0;
        else
            x00(1,i) = 1;
        end
        end
    
    if((x00(1, i) == 1)&&(dne == 1))
        x00(1, i) = 1; dne = 0;
    end 
    i = i-1;
end
else
    xx = y;
x00 = fix(rem(xx(1, 1)*pow2(-(n-1):m),2));
end
x0_0(j, 1:16) = x00(1, 1:16);
end

% x1 ===>  Converting into binary and doing 2's complement

for j = 1:10000

n = 5;         % number bits for integer part of your number      
m = 11;         % number bits for fraction part of your number
    
y = x1(j, 1);

if y < 0.0
    xx = -y;         
x00 = fix(rem(xx(1, 1)*pow2(-(n-1):m),2));
i = 16; dne = 1;
while (i >= 1)
    
        if (dne == 0)
        if(x00(1, i) == 1)
            x00(1, i) = 0;
        else
            x00(1,i) = 1;
        end
        end
    
    if((x00(1, i) == 1)&&(dne == 1))
        x00(1, i) = 1; dne = 0;
    end 
    i = i-1;
end
else
    xx = y;
x00 = fix(rem(xx(1, 1)*pow2(-(n-1):m),2));
end
x1_1(j, 1:16) = x00(1, 1:16);
end

%Writing the final results into x0.txt and x1.txt files 

fileID = fopen('x0.txt','w');
for i = 1:10000
    for j = 1:16
fprintf(fileID,'%d',x0_0(i, j));
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
fileID1 = fopen('x1.txt','w');
for i = 1:10000
    for j = 1:16
fprintf(fileID1,'%d',x1_1(i, j));
    end
    fprintf(fileID1,'\n');
end
fclose(fileID1);
