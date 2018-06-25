% Based on week 7, Q1, Part (a): Transient removal   

% load the files 
load departure_1.txt 
load departure_2.txt  
load departure_3.txt  
load departure_4.txt  
load departure_5.txt  

% Min number of data points in each simulation
m = min([length(departure_1),length(departure_2),length(departure_3),length(departure_4),length(departure_5)]);

%Calculate the response time and standardize the length.
trace1 = departure_1(1:m,2) - departure_1(1:m,1);
trace2 = departure_2(1:m,2) - departure_2(1:m,1);
trace3 = departure_3(1:m,2) - departure_3(1:m,1);
trace4 = departure_4(1:m,2) - departure_4(1:m,1);
trace5 = departure_5(1:m,2) - departure_5(1:m,1);

% put the traces in an array
nsim = 5;     % number of simulation
response_time_traces = zeros(nsim,m);
for i = 1:5
    eval(['response_time_traces(i,:) = trace',num2str(i),';']);
end    

% Compute the mean over the 5 replications
mt = mean(response_time_traces);

% smooth it out with different values of w
% vary the value of w here 
w = 1000;
mt_smooth = zeros(1,m-w);

    for i = 1:(m-w)
        if (i <= w)
            mt_smooth(i) = mean(mt(1:(2*i-1)));
        else
            mt_smooth(i) = mean(mt((i-w):(i+w)));
        end
    end

% plot the smoothed batch mean
xv = 1:(m-w);
plot(mt_smooth','Linewidth',3);
title(['w = ',int2str(w)],'FontSize',16)









