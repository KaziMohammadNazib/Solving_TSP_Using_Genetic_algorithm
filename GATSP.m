clear all; 
clc;

% Input Data
data=load(''); %file path 
didx=[data(:,1)];
data=[data(:,2) data(:,3)];
[data_n,in_n] = size(data);
%Distance Matrix
[DM,FM]=DistM(data);


nump=100; %number of population
numex = 10; %number of experiment 
tic;
for k = 1: numex
    for i=1:nump
        pop(i,:)=randperm(data_n);
    end

    pop = arroute(DM,pop);

    %genetic algorithm
    mutationProb=.01;
    gen=100;
    orderCR=0.7;

    for i=1:gen

        %selection : Family Father 
            father = pop(1,:);
            Child(1,:) = father;
        % Crossover : order    
            for j = 2:nump
                Child(j,:)= crossover(father,pop(j,:),orderCR);
        %Inmutation part, Use one of the two    
        %mutation : SWAP
                %Child(j,:) =RSSM(Child(j,:),mutationProb) ;

        %mutation : Inverse
                Child(j,:)=FRM(Child(j,:),mutationProb);

            end
            pop = arroute(DM,Child);
            genbest(i)=SRiF(DM,pop(1,:));

    end
    optim(k,:)=genbest;
    time(k)=toc;
    Experiment_count=k
    Best_Route_length(k)= SRiF(DM,pop(1,:));
end

[BEST,idx]=min(Best_Route_length);
BEST
plot(optim(idx,:))
AVG=mean(Best_Route_length)
Worst=max(Best_Route_length)

AVG_time=mean(time) 
            












function [DM,FM]=DistM(data)
d=data;
x=d(:,1);
y=d(:,2);
n=length(x);
for i=1:n
    for j=1:n
        if i<j
            DM(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            FM(i,j)=1/DM(i,j);
        elseif i==j
                DM(i,j)=0;
                FM(i,j)=0;
        else i>j;
            DM(i,j)=DM(j,i);
            FM(i,j)=FM(j,i);
        end
    end           
end
end

function pop = arroute(DM,pop)
    
    Rlgth=RouteFitness(DM,pop);
    nump = size(pop,1);
    [X,idx]=sort(Rlgth,'ascend');         
    pop((1:nump),:) = pop(idx(1:nump),:);

end

function RouteFittness=RouteFitness(DM,routes)
    ZZZ=size(routes,1);

    for i=1:ZZZ
        RouteFittness(i)=SRiF(DM,routes(i,:));
    end
end



function SRF = SRiF(DM,Route)
Route=[Route Route(1,1)];
XX=size(Route,2);
a=0;
        for j=1:XX-1
            a=a+DM(Route(1,j),Route(1,j+1));
        end
        SRF=a;
end

  function G=RSSM(G,pm)
    % mutation of exchange 2 random cities:
  nn=size(G,2);
        if rand<pm
            rnp=ceil(nn*rand); % random number of sicies to permuation
            rpnn=randperm(nn);
            ctp=rpnn(1:rnp); %chose rnp random cities to permutation
            Gt=G(1,ctp); % get this cites from the list
            Gt=Gt(randperm(rnp)); % permutate cities
            G(1,ctp)=Gt; % % return citeis back
        end
  end


function child = crossover(parent1,parent2,CR)
        N=length(parent1);
%         CR=rand()
        subLength=round(N*CR);
%         subLength=randi(N/2);
        % Create a new empty route
        child = zeros(1,N);
        
        % Get start and end position for a subset
        %subLength = 3; % How many cities are in one segment (constant for now)
        subStart = randi([2 ((N+1)-subLength)] , 1); % Generates a random integer from 2 to N-segLength
        subEnd = subStart + subLength;
        
        % Get the subset from parent1 and add it to the child
        subset = parent1(subStart:(subEnd-1));
        
        % Add the subset to the child
        % At the same indices as the parent
        for k=1:1:size(subset,2)
            child(1,(k+subStart)-1) = subset(1,k);
        end
        
        % Remove the numbers of the subset from parent2
        for k=1:1:size(subset,2)
            idx = find(parent2 == subset(1,k));
            parent2(idx) = [];
        end
        
        % Add the remaining elements to the child, in the order of parent2
        count = 1;
        for b=1:1:size(child,2)
            if child(1,b) == 0;
                child(1,b) = parent2(1,count);
                count = count + 1;
            end
        end
end

function G=FRM(G,pmf)
% mutation  of flip randm pece of path:
 %nn is number of cities
%g is a route
nn=size(G,2);

        if rand<pmf
            n1=ceil(nn*rand);
            n2=ceil(nn*rand);
            G(1,n1:n2)=fliplr(G(1,n1:n2));
        end
end
