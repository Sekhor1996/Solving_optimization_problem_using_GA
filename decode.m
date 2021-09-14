function x=decode(S,xmin,xmax)
l_i=length(S);
vec=2.^(l_i-1:-1:0);
decoded=dot(S,vec);
x=xmin+(xmax-xmin)*decoded/(2^l_i-1);