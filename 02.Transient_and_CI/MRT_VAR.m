% Based on week 7, Q1, Part (a): Transient removal   

% load the files 
load departure_1.txt 
load departure_2.txt  
load departure_3.txt  
load departure_4.txt  
load departure_5.txt  

% Min number of data points in each simulation
ndp = min([length(departure_1),length(departure_2),length(departure_3),length(departure_4),length(departure_5)]);

%Calculate the response time and standardize the length.
trace1 = departure_1(1:ndp,2) - departure_1(1:ndp,1);
trace2 = departure_2(1:ndp,2) - departure_2(1:ndp,1);
trace3 = departure_3(1:ndp,2) - departure_3(1:ndp,1);
trace4 = departure_4(1:ndp,2) - departure_4(1:ndp,1);
trace5 = departure_5(1:ndp,2) - departure_5(1:ndp,1);

% put the traces in an array
nsim = 5;     % number of simulation
response_time_traces = zeros(nsim,ndp);
for i = 1:5
    eval(['response_time_traces(i,:) = trace',num2str(i),';']);
end    

% Drop the first X points as the transient
% Compute the mean
x = 200;
mt = mean(response_time_traces(:,x+1:end)');

% Find the mean and standard deviation of mt
mean(mt)
std(mt)

% Confidence interval for difference in EMRT
x = reshape(response_time_traces(:,x+1:end),[],1);                      % Create Data
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
ConfI = mean(x) + ts*SEM;                      % Confidence Intervals







