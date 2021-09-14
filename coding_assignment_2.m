clear
clc
%Input parameters
N=1000; %Population size
pc=0.95; %Crossover probability
pm=0.01; %Mutation probability
Gen_max=500; %Maximum generations
%Range of decision variables
xmin=0;
xmax=0.5;
%Desired accuracy
epsilon=1e-6;
%String length
l_i=ceil(log2((xmax-xmin)/epsilon));
l_str=2*l_i;
%% Initialization of population of solutions
S=randi([0 1],N,l_str);

fitness=zeros(N,1);
avg_fitness=zeros(Gen_max,1);
min_fitness=zeros(Gen_max,1);
max_fitness=zeros(Gen_max,1);
%% GA loop
X_mean=zeros(Gen_max,2);
for gen=1:Gen_max
    X_gen=zeros(N,2);
    for i=1:N
        S1=S(i,1:l_i);
        S2=S(i,l_i+1:size(S,2));
        x1=decode(S1,xmin,xmax);
        x2=decode(S2,xmin,xmax);
        X_gen(i,1)=x1;
        X_gen(i,2)=x2;
        fitness(i)=obj_func(x1,x2);
    end
    x1_mean=mean(X_gen(:,1));
    x2_mean=mean(X_gen(:,2));
    X_mean(gen,:)=[x1_mean x2_mean];
    %Reproduction by Roulette Wheel Selection
    p=fitness/sum(fitness);
    pool=zeros(size(S,1),size(S,2));
    idx=zeros(length(fitness),1);
    cum_p=cumsum(p);
    cum_p=[0;cum_p];
    for i=1:N
        r=rand;
        for j=1:N
            if (r>=cum_p(j) && r<=cum_p(j+1))
                idx(i)=j;
                break
            end
        end
        pool(i,:)=S(idx(i),:);
    end
    
    parent_idx=randperm(N);
    parent=zeros(N,l_str);
    child=zeros(N,l_str);
    %Randomizing the mating pool
    for i=1:N
        parent(i,:)=pool(parent_idx(i),:);
    end
    %Crossover
    for i=1:2:N
        r=rand;
        Pr1=parent(i,:);
        Pr2=parent(i+1,:);
        if (r<=pc)
            [Ch1,Ch2]=crossover(Pr1,Pr2);
        else
            Ch1=Pr1;
            Ch2=Pr2;
        end
        child(i,:)=Ch1;
        child(i+1,:)=Ch2;
    end
    
    %Mutation
    for i=1:N
        for j=1:l_str
            r=rand;
            if (r<=pm)
                child(i,j)=1-child(i,j);
            end
        end
    end
    %Evaluating average fitness
    avg_fitness(gen)=mean(fitness);
    %Evaluating minimum fitness
    min_fitness(gen)=min(fitness);
    %Evaluating maximum fitness
    max_fitness(gen)=max(fitness);
    %Updating the solution
    S=child;
end
%% Optimal solution
[fitness_opt,idx_opt]=max(fitness);
fitness_opt=1/fitness_opt -1;
x_opt=X_gen(idx_opt,:);
fprintf("The optimum fitness value is:%f\n",fitness_opt)
fprintf("The optimum value of x1=%f\n",x_opt(1))
fprintf("The optimum value of x2=%f\n",x_opt(2))
%% Plotting the results
figure(1)
plot(1:Gen_max,avg_fitness)
xlabel("No. of generations")
ylabel("Average fitness value")

figure(2)
plot(1:Gen_max,min_fitness,1:Gen_max,max_fitness)
xlabel("No. of generations")
ylabel("Fitness value")
legend("Minimum fitness","Maximum fitness")
axis([0 Gen_max 0.5 1.1])

figure(3)
plot(1:Gen_max,X_mean(:,1),1:Gen_max,X_mean(:,2))
xlabel("No. of generations")
ylabel("Optimal solution")
legend("x1","x2")