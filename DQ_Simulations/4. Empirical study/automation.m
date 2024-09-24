% October 12, 2020
clc;
clear;
Sim=50; 
J = 3; % the number of alternatives
N = 1000; %the number of individuals
NT = 7*N;  % the number of time periods observed for each individual
nrx = 5; % number of x variables with random coefficients
ide_par = nrx+nrx*(nrx+1)*.5; % number of parameters
NROWS = NT*J;
data = xlsread('automation.xlsx');
Xr = data(:,4:8);
Y = data(:,3);

R_set_M = [50,100,200,300,1000]; 
R_set_H = [50,100,200,300,1000]; 

% MLHS
Mmean = zeros(ide_par,length(R_set_M),Sim);
Mstd = zeros(ide_par,length(R_set_M),Sim);
Mfval = zeros(length(R_set_M),Sim); %  draws x number of simulations
Mtime = zeros(length(R_set_M),Sim); % draws x number of simulations
Miter = zeros(length(R_set_M),Sim); % draws x number of simulations
Mfun = zeros(length(R_set_M),Sim); % draws x number of simulations

% Halton
Hmean = zeros(ide_par,length(R_set_H),Sim);
Hstd = zeros(ide_par,length(R_set_H),Sim);
Hfval = zeros(length(R_set_H),Sim); %  draws x number of simulations
Htime = zeros(length(R_set_H),Sim); % draws x number of simulations
Hiter = zeros(length(R_set_H),Sim); % draws x number of simulations
Hfun = zeros(length(R_set_H),Sim); % draws x number of simulations

% Quadrature
Q_plan = xlsread('sim_plan_dq.xlsx','d=5');

Qmean = zeros(ide_par,length(Q_plan(:,1)),Sim);
Qstd = zeros(ide_par,length(Q_plan(:,1)),Sim);       
Qfval = zeros(length(Q_plan(:,1)),Sim);
Qtime = zeros(length(Q_plan(:,1)),Sim);
Qiter = zeros(length(Q_plan(:,1)),Sim); % draws x number of simulations
Qfun = zeros(length(Q_plan(:,1)),Sim); % draws x number of simulations


for SS =1:Sim     
    if SS==25
        rng(SS*10); % This is because model did not converge for rng(25) 
    else
        rng(SS);
    end
    SS
    B = standardlogit(Y,Xr,NT,J);
    initial = [B; rand(nrx*(nrx+1)*.5,1)];
    options=optimset('LargeScale','off','GradObj','on','DerivativeCheck','off','Display','off');

    %%% MLHS   
    for ndraw = 1:length(R_set_M)
        R = R_set_M(ndraw); %Number of simulation Draws
        
        
        dr_sn = makedraws(nrx,N,4,R); % type=4 for MLHS        
        fnew = @(x) flexll_grad(x, Xr,Y, J, N, R, NT, nrx,dr_sn);
        tic
        [paramhat,fval,~,output,~,hessian]=fminunc(fnew,initial,options);
        Mtime(ndraw,SS) = toc;
        Mmean(:,ndraw,SS) = paramhat;
        Mstd(:,ndraw,SS) = sqrt(diag(inv(hessian)));        
        Mfval(ndraw,SS) = fval;   
        Miter(ndraw,SS) = output.iterations;
        Mfun(ndraw,SS) = output.funcCount;
    end   
    %%% shuffled and scrambled Halton    
    for ndraw = 1:length(R_set_H)
        R = R_set_H(ndraw); %Number of simulation Draws        
        dr_sn = makedraws(nrx,N,3,R); % type=3 for shuffled and scrambled Halton        
        fnew = @(x) flexll_grad(x, Xr,Y, J, N, R, NT, nrx,dr_sn);
        tic
        [paramhat,fval,~,output,~,hessian]=fminunc(fnew,initial,options);
        Htime(ndraw,SS) = toc;
        Hmean(:,ndraw,SS) = paramhat;
        Hstd(:,ndraw,SS) = sqrt(diag(inv(hessian)));        
        Hfval(ndraw,SS) = fval;
        Hiter(ndraw,SS) = output.iterations;
        Hfun(ndraw,SS) = output.funcCount;
    end   
    % Quadrature
    for ndraw = 1:length(Q_plan(:,1))
        acc=Q_plan(ndraw,1); R=Q_plan(ndraw,2);
        filename = sprintf('TO_d_%d_accu_%d_node_%d.xlsx', nrx,acc,R);
        XW = xlsread(filename);
        node = XW(:,1:nrx);
        weight = XW(:,end);
        tic
        fnew = @(x) flexll2008_grad(x,Xr,Y, J, N, R, NT, nrx,node, weight);
        [paramhat,fval,~,output,~,hessian]=fminunc(fnew,initial,options);
        Qtime(ndraw,SS) = toc;
        Qmean(:,ndraw,SS) = paramhat;
        Qstd(:,ndraw,SS) = sqrt(diag(inv(hessian)));        
        Qfval(ndraw,SS) = fval;
        Qiter(ndraw,SS) = output.iterations;
        Qfun(ndraw,SS) = output.funcCount;
    end 
end
save('automation_output.mat','Mfval', 'Hfval', 'Qfval', 'Mtime', 'Htime', 'Qtime', 'Miter', 'Hiter', 'Qiter', 'Hfun', 'Mfun','Qfun','Mmean', 'Hmean', 'Qmean', 'Mstd','Hstd','Qstd', 'R_set_M', 'R_set_H', 'Q_plan', 'nrx','Sim')
 
