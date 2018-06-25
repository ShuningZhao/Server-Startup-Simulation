load ImprovedDepartures\departure_1.txt 
load ImprovedDepartures\departure_2.txt  
load ImprovedDepartures\departure_3.txt  
load ImprovedDepartures\departure_4.txt  
load ImprovedDepartures\departure_5.txt 

% Remove the first 200 rows as per Transient Removal
x = 200;
departure_6 = departure_1(x+1:end,:);
departure_7 = departure_2(x+1:end,:);
departure_8 = departure_3(x+1:end,:);
departure_9 = departure_4(x+1:end,:);
departure_10 = departure_5(x+1:end,:);

load BaselineDepartures\departure_1.txt 
load BaselineDepartures\departure_2.txt  
load BaselineDepartures\departure_3.txt  
load BaselineDepartures\departure_4.txt  
load BaselineDepartures\departure_5.txt  

% Remove the first 500 rows as per Transient Removal
x = 500;
departure_1 = departure_1(x+1:end,:);
departure_2 = departure_2(x+1:end,:);
departure_3 = departure_3(x+1:end,:);
departure_4 = departure_4(x+1:end,:);
departure_5 = departure_5(x+1:end,:);

% Min number of data points in each simulation
m_base = min([length(departure_1),length(departure_2),length(departure_3),length(departure_4),length(departure_5)]);
m_impv = min([length(departure_6),length(departure_7),length(departure_8),length(departure_9),length(departure_10)]);

% Calculate the response time and standardize the length.
trace1 = departure_1(1:m_base,2) - departure_1(1:m_base,1);
trace2 = departure_2(1:m_base,2) - departure_2(1:m_base,1);
trace3 = departure_3(1:m_base,2) - departure_3(1:m_base,1);
trace4 = departure_4(1:m_base,2) - departure_4(1:m_base,1);
trace5 = departure_5(1:m_base,2) - departure_5(1:m_base,1);

trace6 = departure_6(1:m_impv,2) - departure_6(1:m_impv,1);
trace7 = departure_7(1:m_impv,2) - departure_7(1:m_impv,1);
trace8 = departure_8(1:m_impv,2) - departure_8(1:m_impv,1);
trace9 = departure_9(1:m_impv,2) - departure_9(1:m_impv,1);
trace10 = departure_10(1:m_impv,2) - departure_10(1:m_impv,1);

% Calculate the difference in EMRT
D_MRT1 = mean(trace1)-mean(trace6);
D_MRT2 = mean(trace2)-mean(trace7);
D_MRT3 = mean(trace3)-mean(trace8);
D_MRT4 = mean(trace4)-mean(trace9);
D_MRT5 = mean(trace5)-mean(trace10);

% Confidence interval for difference in EMRT
x = [D_MRT1, D_MRT2, D_MRT3, D_MRT4, D_MRT5];                      % Create Data
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
ConfI = mean(x) + ts*SEM;                      % Confidence Intervals