function [Ch1,Ch2] = crossover(Pr1,Pr2)
r1=randi(length(Pr1)-2);
r2=randi([r1+1,length(Pr1)-1]);
Ch1=[Pr1(1:r1),Pr2(r1+1:r2),Pr1(r2+1:end)];
Ch2=[Pr2(1:r1),Pr1(r1+1:r2),Pr2(r2+1:end)];
end

