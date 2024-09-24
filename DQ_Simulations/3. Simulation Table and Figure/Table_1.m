%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% Create upper part of Table 1 %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

clc; clear; 
load('DIAG_3rand_output.mat')
diag = 1;

fin_Mfval = mean(Mfval,2);
fin_Hfval = mean(Hfval,2); 
fin_Qfval = mean(Qfval,2);

fin_Mtime = mean(Mtime,2);
fin_Htime = mean(Htime,2); 
fin_Qtime = mean(Qtime,2);

fin_Miter = mean(Miter,2);
fin_Hiter = mean(Hiter,2); 
fin_Qiter = mean(Qiter,2);

fin_Mfun = mean(Mfun,2);
fin_Hfun = mean(Hfun,2); 
fin_Qfun = mean(Qfun,2);

if (nrx ==3)
    ref = 3; 
    if (diag==1)
        ind = [1:2 4 6 9];  
    else
        ind = [1:2 4:9];  
    end
    
elseif (nrx==5)
    ref = 5; 
    if (diag==1)
        ind = [1:4 6 8 11 15 20]; 
    else
        ind = [1:4 6:20]; 
    end
else
    ref = 10; 
    if (diag==1)
       ind = [1:9 11 13 16 20 25 31 38 46 55 65]; 
    else
       ind = [1:9 11:65];  
    end
end

%t-stat
fin_Mmean = Mmean(ind,:,:)./repmat(Mmean(ref,:,:),length(ind), 1,1); 
fin_Hmean = Hmean(ind,:,:)./repmat(Hmean(ref,:,:),length(ind), 1,1); 
fin_Qmean = Qmean(ind,:,:)./repmat(Qmean(ref,:,:),length(ind), 1,1);

fin_Mfsse = std(fin_Mmean,[],3);
fin_Hfsse = std(fin_Hmean,[],3); 
fin_Qfsse = std(fin_Qmean,[],3);

fin_Mtrue = repmat(parameter(ind,1) / parameter(ref), 1, length(R_set_M)); 
fin_Htrue = repmat(parameter(ind,1) / parameter(ref), 1, length(R_set_H)); 
fin_Qtrue = repmat(parameter(ind,1) / parameter(ref), 1, length(Q_plan(:,1))); 

fin_Mtstat = mean(abs((fin_Mtrue - mean(fin_Mmean,3))./fin_Mfsse),1)';
fin_Htstat = mean(abs((fin_Htrue - mean(fin_Hmean,3))./fin_Hfsse),1)';
fin_Qtstat = mean(abs((fin_Qtrue - mean(fin_Qmean,3))./fin_Qfsse),1)';

%APB
APB_M = 100*mean(mean(abs((fin_Mmean - repmat(fin_Mtrue,1,1,Sim))./ repmat(fin_Mtrue,1,1,Sim)),3),1)';
APB_H = 100*mean(mean(abs((fin_Hmean - repmat(fin_Htrue,1,1,Sim))./ repmat(fin_Htrue,1,1,Sim)),3),1)';
APB_Q = 100*mean(mean(abs((fin_Qmean - repmat(fin_Qtrue,1,1,Sim))./ repmat(fin_Qtrue,1,1,Sim)),3),1)';

ind_MH = [1:3 5];
ind_DQ_r6 = [1:3];
ind_DQ_r7 = [4:5];

table_1_upper = zeros(4, 20);

table_1_upper(:,1) =  fin_Hfval(ind_MH); 
table_1_upper(:,2) =  fin_Mfval(ind_MH); 
table_1_upper(1:3,3) =  fin_Qfval(ind_DQ_r6); 
table_1_upper(2:3,4) =  fin_Qfval(ind_DQ_r7); 

table_1_upper(:,5) =  APB_H(ind_MH); 
table_1_upper(:,6) =  APB_M(ind_MH); 
table_1_upper(1:3,7) =  APB_Q(ind_DQ_r6); 
table_1_upper(2:3,8) =  APB_Q(ind_DQ_r7); 

table_1_upper(:,9) =  fin_Htime(ind_MH); 
table_1_upper(:,10) =  fin_Mtime(ind_MH); 
table_1_upper(1:3,11) =  fin_Qtime(ind_DQ_r6); 
table_1_upper(2:3,12) =  fin_Qtime(ind_DQ_r7); 

table_1_upper(:,13) =  fin_Hfun(ind_MH); 
table_1_upper(:,14) =  fin_Mfun(ind_MH); 
table_1_upper(1:3,15) =  fin_Qfun(ind_DQ_r6); 
table_1_upper(2:3,16) =  fin_Qfun(ind_DQ_r7); 

table_1_upper(:,17) =  fin_Htstat(ind_MH); 
table_1_upper(:,18) =  fin_Mtstat(ind_MH); 
table_1_upper(1:3,19) =  fin_Qtstat(ind_DQ_r6); 
table_1_upper(2:3,20) =  fin_Qtstat(ind_DQ_r7); 
table_1_upper(table_1_upper==0) = " ";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% Create lower part of Table 1 %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


load('NONdiag_3rand_output.mat')
diag = 0;

fin_Mfval = mean(Mfval,2);
fin_Hfval = mean(Hfval,2); 
fin_Qfval = mean(Qfval,2);

fin_Mtime = mean(Mtime,2);
fin_Htime = mean(Htime,2); 
fin_Qtime = mean(Qtime,2);

fin_Miter = mean(Miter,2);
fin_Hiter = mean(Hiter,2); 
fin_Qiter = mean(Qiter,2);

fin_Mfun = mean(Mfun,2);
fin_Hfun = mean(Hfun,2); 
fin_Qfun = mean(Qfun,2);

if (nrx ==3)
    ref = 3; 
    if (diag==1)
        ind = [1:2 4 6 9];  
    else
        ind = [1:2 4:9];  
    end
    
elseif (nrx==5)
    ref = 5; 
    if (diag==1)
        ind = [1:4 6 8 11 15 20]; 
    else
        ind = [1:4 6:20]; 
    end
else
    ref = 10; 
    if (diag==1)
       ind = [1:9 11 13 16 20 25 31 38 46 55 65]; 
    else
       ind = [1:9 11:65];  
    end
end

%t-stat
fin_Mmean = Mmean(ind,:,:)./repmat(Mmean(ref,:,:),length(ind), 1,1); 
fin_Hmean = Hmean(ind,:,:)./repmat(Hmean(ref,:,:),length(ind), 1,1); 
fin_Qmean = Qmean(ind,:,:)./repmat(Qmean(ref,:,:),length(ind), 1,1);

fin_Mfsse = std(fin_Mmean,[],3);
fin_Hfsse = std(fin_Hmean,[],3); 
fin_Qfsse = std(fin_Qmean,[],3);

fin_Mtrue = repmat(parameter(ind,1) / parameter(ref), 1, length(R_set_M)); 
fin_Htrue = repmat(parameter(ind,1) / parameter(ref), 1, length(R_set_H)); 
fin_Qtrue = repmat(parameter(ind,1) / parameter(ref), 1, length(Q_plan(:,1))); 

fin_Mtstat = mean(abs((fin_Mtrue - mean(fin_Mmean,3))./fin_Mfsse),1)';
fin_Htstat = mean(abs((fin_Htrue - mean(fin_Hmean,3))./fin_Hfsse),1)';
fin_Qtstat = mean(abs((fin_Qtrue - mean(fin_Qmean,3))./fin_Qfsse),1)';

%APB
APB_M = 100*mean(mean(abs((fin_Mmean - repmat(fin_Mtrue,1,1,Sim))./ repmat(fin_Mtrue,1,1,Sim)),3),1)';
APB_H = 100*mean(mean(abs((fin_Hmean - repmat(fin_Htrue,1,1,Sim))./ repmat(fin_Htrue,1,1,Sim)),3),1)';
APB_Q = 100*mean(mean(abs((fin_Qmean - repmat(fin_Qtrue,1,1,Sim))./ repmat(fin_Qtrue,1,1,Sim)),3),1)';

ind_MH = [1:4];
ind_DQ_r6 = [1:3];
ind_DQ_r7 = [4:5];

table_1_lower = zeros(4, 20);
table_1_lower(:,1) =  fin_Hfval(ind_MH); 
table_1_lower(:,2) =  fin_Mfval(ind_MH); 
table_1_lower(1:3,3) =  fin_Qfval(ind_DQ_r6); 
table_1_lower(2:3,4) =  fin_Qfval(ind_DQ_r7); 

table_1_lower(:,5) =  APB_H(ind_MH); 
table_1_lower(:,6) =  APB_M(ind_MH); 
table_1_lower(1:3,7) =  APB_Q(ind_DQ_r6); 
table_1_lower(2:3,8) =  APB_Q(ind_DQ_r7); 

table_1_lower(:,9) =  fin_Htime(ind_MH); 
table_1_lower(:,10) =  fin_Mtime(ind_MH); 
table_1_lower(1:3,11) =  fin_Qtime(ind_DQ_r6); 
table_1_lower(2:3,12) =  fin_Qtime(ind_DQ_r7); 

table_1_lower(:,13) =  fin_Hfun(ind_MH); 
table_1_lower(:,14) =  fin_Mfun(ind_MH); 
table_1_lower(1:3,15) =  fin_Qfun(ind_DQ_r6); 
table_1_lower(2:3,16) =  fin_Qfun(ind_DQ_r7); 

table_1_lower(:,17) =  fin_Htstat(ind_MH); 
table_1_lower(:,18) =  fin_Mtstat(ind_MH); 
table_1_lower(1:3,19) =  fin_Qtstat(ind_DQ_r6); 
table_1_lower(2:3,20) =  fin_Qtstat(ind_DQ_r7); 
table_1_lower(table_1_lower==0) = " ";


table_1 = [table_1_upper; table_1_lower];

% Creat input file for a plot 
three_d_plot = zeros(9,2); 
three_d_plot(1:3,1) = table_1(1:3,9);
three_d_plot(1:3,2) = table_1(1:3,5);

three_d_plot(4:6,1) = table_1(1:3,10);
three_d_plot(4:6,2) = table_1(1:3,6);

three_d_plot(7:9,1) = table_1(1:3,11);
three_d_plot(7:9,2) = table_1(1:3,7);
three_d_plot = round(three_d_plot,1);

three_nd_plot = zeros(9,2); 
three_nd_plot(1:3,1) = table_1(5:7,9);
three_nd_plot(1:3,2) = table_1(5:7,5);

three_nd_plot(4:6,1) = table_1(5:7,10);
three_nd_plot(4:6,2) = table_1(5:7,6);

three_nd_plot(7,1) = table_1(5,11);
three_nd_plot(7,2) = table_1(5,7);
three_nd_plot(8:9,1) = table_1(6:7,12);
three_nd_plot(8:9,2) = table_1(6:7,8);

three_nd_plot = round(three_nd_plot,1);

col_header={'time','apb'};
c1 = cell(10,2);
c1(1,:) = col_header;
c1(2:10,:) = num2cell(three_d_plot);

c2 = cell(10,2);
c2(1,:) = col_header;
c2(2:10,:) = num2cell(three_nd_plot);


xlswrite('three_d.xlsx',c1);
xlswrite('three_full.xlsx',c2);