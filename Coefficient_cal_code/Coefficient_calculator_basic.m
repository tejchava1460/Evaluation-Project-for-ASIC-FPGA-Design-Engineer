clear all;

n = 3;
i = 0:1:n-1;
    t(i+1 , 1) = cos((2*i+1)*pi/(2*n))

size = 1;


j = 0;

for a = 1:size:(2 - size)
    b = a+size;
    j = j+1;
   for i = 1:3
    y(i , j) = (t(i, 1) * (b - a) + (b + a))/2 ;
   end

end
r = n;
c = j

syms x;



for k = 1:c
p = y(1, k);
q = y(2, k);
r = y(3, k);
    
 simplify((-log(p)*(x - q)*(x - r))/((p - q)*(p - r)) +  (-log(q)*(x - p)*(x - r))/((q - p)*(q - r)) +  (-log(r)*(x - q)*(x - p))/((r - q)*(r - p)))

end

    

