<h1><center>
Simulation on Server Setup in Data Centres

**Shuning Zhao June 2018**
</center></h1>

**Introduction**  
This report is about the simulation of a data center with one dispatcher and five servers. Where we try to study the dilemma faced by data center operators on the trade-off between energy consumption and latency. The sections of this report include verification of the correctness of the interarrival probability distribution and service time distribution, verification of the correctness of the simulation code, implementation of reproducible results, statistical analysis of simulation results and explanation of how the simulation parameters are chosen.

**Description of the server system**  
Figure 1 depicts the computer system to be considered in this project. The system consists of a
dispatcher as its front-end and m servers at its back-end. There is only one queue and it is located
at the dispatcher; there are no queues at the computer servers. You can assume that:

* The dispatcher has sufficient memory so the number of waiting room for queueing can be
considered to be infinite.
* The communication between the dispatcher and the server is fast. This means that once a
server has finished working on a job, it can inform the dispatcher immediately. It also means
that it takes the dispatcher negligible time to send a job to a server.
* The dispatcher takes negligible time to make a decision.

 ![Figure 1](https://github.com/ShuningZhao/Server-Startup-Simulation/blob/master/01.KS_Test/fig1.png?raw=true)

Figure 1: Architecture of a computer system. The front-end consists of a dispatcher and the
back-end has a number of computer servers. There is a queue at the dispatcher. There are no
queues at the servers.

All servers remain on at all times. A server can only have two states: busy or idle. An arriving job will be
served immediately if there is an idling server, otherwise it will join the queue at the dispatcher.
Once a server has finished processing a job, it will serve the job at the front of the queue if there
is one. In particular, if the inter-arrival time and service time probability distributions are exponential, that this type of multi-server queue could be modelled as an M/M/m queue.

Energy consumption is a major issue faced by data centres. A drawback of the multi-server
queue described in the last paragraph is that the idling servers consume power but are not doing
useful work. There have been various proposals to reduce the power consumption and they are
discussed in Section 3 of A. Gandhi, S. Doroudi, M. Harchol-Balter and A. Scheller-Wolf. ["Exact analysis of the
M/M/k/setup class of Markov chains via recursive renewal reward"](https://link.springer.com/article/10.1007/s11134-014-9409-7), Queueing Systems, 2014. In this simulation we will simulate the setup/delayedoff mode of operation which is similar (but not identical) to that discussed in Section 3.2 of the paper above.

**Verification of the interarrival probability distribution and service time distribution.**  
For the interarrival probability distribution we have an exponential distribution with the mean arrival rate of jobs as λ=0.35.

To verify the random numbers generated are indeed from the distribution mentioned above, I have decided to plot the empirical distribution of the interarrival time from the results of the simulation against the pdf of the theoretical interarrival probability distribution. As well as conducting a Kolmogorov-Smirnov test which is used to decide if a sample comes from a population of a specific distribution (Massey, 1951).

For the baseline system described in the project specifications the empirical distribution of 35052 interarrival times and the exponential distribution with the mean arrival rate of jobs as λ=0.35
 are both plotted in the graph below.

 ![](https://github.com/ShuningZhao/Server-Startup-Simulation/blob/master/01.KS_Test/Baseline_Arrival.png?raw=true)

The results for the Kolmogorov-Smirnov tests are as follow:

 ![](https://raw.githubusercontent.com/ShuningZhao/Server-Startup-Simulation/master/01.KS_Test/arrival_test.bmp)

Where the D-value ![](https://latex.codecogs.com/gif.latex?D%3D%5Csup_x%7CF_n%28x%29-F%28x%29%7C)
 is the max distance between the two sets being compared. And the critical value for N = 35052 at
α = 0.05 level of significance is 0.007

since the D-Value is less than the critical value and the p-value is greater than 0.05 we do not reject the null hypothesis that the interarrival times came from an exponential distribution with the mean arrival rate of the jobs as λ=0.35
.

For service time distribution we let ![](https://latex.codecogs.com/gif.latex?s_k) denote the service time of the k-th job arriving at the dispatcher. Each ![](https://latex.codecogs.com/gif.latex?s_k) is the sum of three random numbers
![](https://latex.codecogs.com/gif.latex?s_k%3Ds_%7B1k%7D&plus;s_%7B2k%7D&plus;s_%7B3k%7D)
 for all k = 1,2,… where ![](https://latex.codecogs.com/gif.latex?s_%7B1k%7D%2C%20s_%7B2k%7D%20%5Ctext%7B%20and%20%7D%20s_%7B3k%7D) are exponentially distributed random numbers with parameter μ.

Since the sum of n iid exponential distributions with rate μ is a gamma distribution with shape n and rate μ (Casella and Berger, 2002).

For the baseline system described in the project specifications with the parameter μ=1
 we have the empirical distribution of 35052 service times and the gamma distribution with shape parameter α=3 and rate β=1 as below.

 ![](https://github.com/ShuningZhao/Server-Startup-Simulation/blob/master/01.KS_Test/Baseline_Departure.png?raw=true)

And the results of the Kolmogorov-Smirnov tests are as follow:

 ![](https://raw.githubusercontent.com/ShuningZhao/Server-Startup-Simulation/master/01.KS_Test/service_test.bmp)

Where the critical value for N = 35052 at α=0.05 level of significance is 0.007

since the D-Value is less than the critical value and the p-value is greater than 0.05 we do not reject the null hypothesis that the service times came from a gamma distribution with the shape parameter α=3 and rate β=1.

Similar outputs were also achieved for the improved system since the seeds used for random number generation were identical to the baseline system.

The relative codes are stored in the folder **01.KS\_Test** where the file **KS\_Test.ipynb** contains the code for both the plots and the Kolmogorov-Smirnov tests. The file **arrival.csv** and **service.csv** contains the interarrival and service time data respectively.

**Verification of the correctness of the simulation code.**  
To verify that the code used for my simulation are correct, I have run the two examples provided in the project specification. On top of that I have also ran a random simulation with the arrival and service time printed out. Calculated the results by hand to see if it matches with my results, then loaded the same arrival time and service times into trace mode to see if the results also match one of such examples can be found in the **Test 3** folder in **Unit Test**.

For random model I have also ran multiple repetitions checking if there are any departure times that exceeds the time\_end defined for the simulation.

On top of all that, I have also run multiple test where I have printed out the arrival time and service time in random mode, re-loading it into trace model to see if my results are consistent. The results of my test can be found in the folder **Unit Test** in the zip file submitted.

**Implementation of reproducible results**  
| Simulation Number | Tc | Seed |
| --- | --- | --- |
| Simulation 1 | 0.1 | 100 |
| Simulation 2 | 0.1 | 150 |
| Simulation 3 | 0.1 | 230 |
| Simulation 4 | 0.1 | 123 |
| Simulation 5 | 0.1 | 156 |
| Simulation 6 | 10 | 100 |
| Simulation 7 | 10 | 150 |
| Simulation 8 | 10 | 230 |
| Simulation 9 | 10 | 123 |
| Simulation 10 | 10 | 156 |
**Statistical Analysis of simulation results.**  
For the baseline system with Tc=0.1
 and time\_end = 20000 after repeating the simulation 5 times with different seeds we get the figure below.

 ![](https://github.com/ShuningZhao/Server-Startup-Simulation/blob/master/01.KS_Test/w1000.png?raw=true)

As we can see from the figure above with w = 1000, the mean response time seems to be oscillating around the value of 6.09, this is probably the mean value. Based on that the suggestion is to cut away the first 500 points for transient removal.

Hence we have for the baseline system Tc=0.1
 the mean response time (mrt) is 6.0776 with standard deviation 0.0225 and the 95% confidence interval is [6.051,6.104].

For the improved system, I choose Tc=10
 with all other parameters remaining the same as the simulations done for the baseline system.

 ![](https://github.com/ShuningZhao/Server-Startup-Simulation/blob/master/01.KS_Test/w1000_2.png?raw=true)

As we can see from the figure above with w = 1000, the mean response time seems to be oscillating around the value of 4.00, this is probably the mean value. Based on that the suggestion is to cut away the first 200 points for transient removal.

Hence, we have for the improved system Tc=10
 the mean response time (mrt) is 4.0348 with standard deviation 0.0117 and the 95% confidence interval is [4.010,4.059].

The detail of all repetitions of the simulation are as follow

|   | MERT baseline | MERT improved | Difference |
| --- | --- | --- | --- |
| Rep. 1 | 6.0803 | 4.0510 | 2.0293 |
| Rep. 2 | 6.0583 | 4.0357 | 2.0227 |
| Rep. 3 | 6.1109 | 4.0402 | 2.0708 |
| Rep. 4 | 6.0550 | 4.0226 | 2.0325 |
| Rep. 5 | 6.0833 | 4.0244 | 2.0589 |

We compute the 95% confidence interval of the data above and the confidence interval is [2.0169, 2.0687] which is higher than 2.

Therefore, we can conclude that when the value of Tc
 is greater than 10, the improved system&#39;s response time is with a high probability that it will be 2 units less than that of the baseline system.

The relative codes are stored in the folder **02.Transient\_and\_CI** where the folders BaselineDepartures and ImprovedDepartures stores the simulation results of each simulation in section 4 of this report. The code **Transient\_Removal.m** was used to plot the graph for transient removal, the code **MRT\_VAR.m** was used to calculate the mean response time, variance and confidence interval after the transient removal and the code **CI.m** calculates the confidence interval for the difference between the mean response times of the baseline and improved systems. All simulation results are stored in the **03.Simulation\_Results** folder.

**Simulation parameters.**

For simulation parameters, the three main parameters I had to choose were the time\_end for random mode simulation, w for transient removal and the number of replications needed.

For time\_end I chose the time 20000 as we can see from the two graphs for transient removal in the previous section. The number of data points were longer than the transient and there are good number of points in the steady state part.

The transient removal I chose w = 1000 as seen from the graphs for transient removal in the previous section for both the baseline and improved system. The curve looked smooth when w = 1000.

For the number of replications, I started off with five replications. After removing the transient, the 95% confidence interval for my estimated mean response time were [6.051,6.104] and [4.010,4.059] for the baseline and improved system respectively. The length of those intervals aren&#39;t very wide hence I have decided to stick with 5 replications.

**References**  
- Casella, G. and Berger, R.L., 2002. _Statistical inference_ (Vol. 2). Pacific Grove, CA: Duxbury.
- Massey Jr, F.J., 1951. The Kolmogorov-Smirnov test for goodness of fit. _Journal of the American statistical Association_, _46_(253), pp.68-78.