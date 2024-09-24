%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% Create upper part of Table 3 %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

clc; clear; 
load('DIAG_10rand_output.mat')
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

ind_MH = [1:3];
ind_DQ_r3 = [1:3];
ind_DQ_r4 = [4:6];
ind_DQ_r5 = 7;

table_3_upper = zeros(3, 25);

table_3_upper(:,1) =  fin_Hfval(ind_MH); 
table_3_upper(:,2) =  fin_Mfval(ind_MH); 
table_3_upper(:,3) =  fin_Qfval(ind_DQ_r3); 
table_3_upper(:,4) =  fin_Qfval(ind_DQ_r4); 
table_3_upper(2,5) =  fin_Qfval(ind_DQ_r5); 

table_3_upper(:,6) =  APB_H(ind_MH); 
table_3_upper(:,7) =  APB_M(ind_MH); 
table_3_upper(:,8) =  APB_Q(ind_DQ_r3); 
table_3_upper(:,9) =  APB_Q(ind_DQ_r4); 
table_3_upper(2,10) =  APB_Q(ind_DQ_r5); 

table_3_upper(:,11) =  fin_Htime(ind_MH); 
table_3_upper(:,12) =  fin_Mtime(ind_MH); 
table_3_upper(:,13) =  fin_Qtime(ind_DQ_r3); 
table_3_upper(:,14) =  fin_Qtime(ind_DQ_r4); 
table_3_upper(2,15) =  fin_Qtime(ind_DQ_r5); 

table_3_upper(:,16) =  fin_Hfun(ind_MH); 
table_3_upper(:,17) =  fin_Mfun(ind_MH); 
table_3_upper(:,18) =  fin_Qfun(ind_DQ_r3); 
table_3_upper(:,19) =  fin_Qfun(ind_DQ_r4); 
table_3_upper(2,20) =  fin_Qfun(ind_DQ_r5); 

table_3_upper(:,21) =  fin_Htstat(ind_MH); 
table_3_upper(:,22) =  fin_Mtstat(ind_MH); 
table_3_upper(:,23) =  fin_Qtstat(ind_DQ_r3); 
table_3_upper(:,24) =  fin_Qtstat(ind_DQ_r4); 
table_3_upper(2,25) =  fin_Qtstat(ind_DQ_r5); 

table_3_upper(table_3_upper==0) = " ";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% Create lower part of Table 3 %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


load('NONdiag_10rand_output.mat')
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

ind_MH = [1:3];
ind_DQ_r3 = [1:3];
ind_DQ_r4 = [4:6];
ind_DQ_r5 = 7;

table_3_lower = zeros(3, 25);

table_3_lower(:,1) =  fin_Hfval(ind_MH); 
table_3_lower(:,2) =  fin_Mfval(ind_MH); 
table_3_lower(:,3) =  fin_Qfval(ind_DQ_r3); 
table_3_lower(:,4) =  fin_Qfval(ind_DQ_r4); 
table_3_lower(2,5) =  fin_Qfval(ind_DQ_r5); 

table_3_lower(:,6) =  APB_H(ind_MH); 
table_3_lower(:,7) =  APB_M(ind_MH); 
table_3_lower(:,8) =  APB_Q(ind_DQ_r3); 
table_3_lower(:,9) =  APB_Q(ind_DQ_r4); 
table_3_lower(2,10) =  APB_Q(ind_DQ_r5); 

table_3_lower(:,11) =  fin_Htime(ind_MH); 
table_3_lower(:,12) =  fin_Mtime(ind_MH); 
table_3_lower(:,13) =  fin_Qtime(ind_DQ_r3); 
table_3_lower(:,14) =  fin_Qtime(ind_DQ_r4); 
table_3_lower(2,15) =  fin_Qtime(ind_DQ_r5); 

table_3_lower(:,16) =  fin_Hfun(ind_MH); 
table_3_lower(:,17) =  fin_Mfun(ind_MH); 
table_3_lower(:,18) =  fin_Qfun(ind_DQ_r3); 
table_3_lower(:,19) =  fin_Qfun(ind_DQ_r4); 
table_3_lower(2,20) =  fin_Qfun(ind_DQ_r5); 

table_3_lower(:,21) =  fin_Htstat(ind_MH); 
table_3_lower(:,22) =  fin_Mtstat(ind_MH); 
table_3_lower(:,23) =  fin_Qtstat(ind_DQ_r3); 
table_3_lower(:,24) =  fin_Qtstat(ind_DQ_r4); 
table_3_lower(2,25) =  fin_Qtstat(ind_DQ_r5); 

table_3_lower(table_3_lower==0) = " ";
table_3 = [table_3_upper; table_3_lower];

% Create data for plot
ten_d_plot = zeros(9,2); 
ten_d_plot(1:3,1) = table_3(1:3,11);
ten_d_plot(1:3,2) = table_3(1:3,6);

ten_d_plot(4:6,1) = table_3(1:3,12);
ten_d_plot(4:6,2) = table_3(1:3,7);

ten_d_plot([7,9],1) = table_3([1,3],14);
ten_d_plot([7,9],2) = table_3([1,3],9);
ten_d_plot(8,1) = table_3(2,15);
ten_d_plot(8,2) = table_3(2,10);

ten_d_plot(:,1) = round(ten_d_plot(:,1),0);
ten_d_plot(:,2) = round(ten_d_plot(:,2),1);

ten_nd_plot = zeros(9,2); 
ten_nd_plot(1:3,1) = table_3(4:6,11);
ten_nd_plot(1:3,2) = table_3(4:6,6);

ten_nd_plot(4:6,1) = table_3(4:6,12);
ten_nd_plot(4:6,2) = table_3(4:6,7);

ten_nd_plot([7,9],1) = table_3([4,6],14);
ten_nd_plot([7,9],2) = table_3([4,6],9);
ten_nd_plot(8,1) = table_3(5,15);
ten_nd_plot(8,2) = table_3(5,10);

ten_nd_plot(:,1) = round(ten_nd_plot(:,1),0);
ten_nd_plot(:,2) = round(ten_nd_plot(:,2),1);

col_header={'time','apb'};
c1 = cell(10,2);
c1(1,:) = col_header;
c1(2:10,:) = num2cell(ten_d_plot);

c2 = cell(10,2);
c2(1,:) = col_header;
c2(2:10,:) = num2cell(ten_nd_plot);


xlswrite('ten_d.xlsx',c1);
xlswrite('ten_full.xlsx',c2);