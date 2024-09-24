%% analysis
clc; clear; 
load('automation_output.mat')

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

fin_Mmean = mean(Mmean,3);
fin_Hmean= mean(Hmean,3);
fin_Qmean= mean(Qmean,3);

fin_Mt = mean(Mmean./Mstd ,3);
fin_Ht= mean(Hmean./Hstd,3);
fin_Qt= mean(Qmean./Qstd,3);

% Table 5 
table_5 = zeros(4, 12);
table_5(:,1) = fin_Hfval(2:5);
table_5(:,2) = fin_Mfval(2:5);
table_5(1:3,3) = fin_Qfval(2:4);
table_5(2:3,4) = fin_Qfval(6:7);

table_5(:,5) = fin_Htime(2:5);
table_5(:,6) = fin_Mtime(2:5);
table_5(1:3,7) = fin_Qtime(2:4);
table_5(2:3,8) = fin_Qtime(6:7);

table_5(:,9) = fin_Hfun(2:5);
table_5(:,10) = fin_Mfun(2:5);
table_5(1:3,11) = fin_Qfun(2:4);
table_5(2:3,12) = fin_Qfun(6:7);


table_5(table_5==0) = " ";

% Table 6 

table_6 = zeros(20, 12);
table_6(:,1) = fin_Hmean(:,3);
table_6(:,2) = fin_Hmean(:,5);

table_6(:,3) = fin_Mmean(:,3);
table_6(:,4) = fin_Mmean(:,5);

table_6(:,5:6) = fin_Qmean(:,6:7);

table_6(:,7) = fin_Ht(:,3);
table_6(:,8) = fin_Ht(:,5);

table_6(:,9) = fin_Mt(:,3);
table_6(:,10) = fin_Mt(:,5);

table_6(:,11:12) = fin_Qt(:,6:7);
table_6 = round(table_6 * 10 )/10; 
