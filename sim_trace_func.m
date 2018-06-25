function [all_arrival_time, all_departure_time, avg_response_time] = sim_trace_func(arrival_file, service_file, m, setup_time, delayedoff_time)
% COMP9334 Capacity Planning
%
% This Matlab file simulates an M/M/m queue with
% mean arrival rate lambda and service rate mu
% 
% It outputs the mean response time 
% 
% There are 4 user simulation parameters:
% 1. Arrival rate lambda
% 2. Service rate mu
% 3. Number of servers 
% 4. Simulation time Tend  
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%
UNMARKED = 0;
MARKED = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accounting parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%
response_time_cumulative = 0; %  The cumulative response time 
num_customer_served = 0; % number of completed customers at the end of the simulation

%
% The mean response time will be given by T/N
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Events
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% There are two events: An arrival event and a departure event
%
% An arrival event is specified by
% next_arrival_time = the time at which the next customer arrives
% service_time_next_arrival = the service time of the next arrival
%
% A departure event is specified by
% next_departure_time = the time at which the next departure occurs
% arrival_time_next_departure = the time at which the next departing
% customer arrives at the system
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialising the events
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Initialising the arrival event 
% 

all_arrival_time_file = importdata(arrival_file);
all_service_time_file = importdata(service_file);
no_of_tasks = length(all_arrival_time_file);
task_index = 1;


next_arrival_time = all_arrival_time_file(task_index);
service_time_next_arrival = all_service_time_file(task_index);
task_index = task_index + 1;

all_departure_time = [];
all_arrival_time = [];
% 
% Initialise both departure events to empty
% Note: We use Inf (= infinity) to denote an empty departure event
% 
% next_departure_time is a m-by-1 vector 
next_departure_time = Inf * ones(m,1); 
next_setup_time = nan * ones(m,1); 
next_expiry_time = nan * ones(m,1); 

% For checking
% events = [next_arrival_time service_time_next_arrival]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialising the Master clock, server status, queue_length,
% buffer_content
% 
% server_status = 1 if busy, 0 if idle
% 
% queue_length is the number of customers in the buffer
% 
% buffer_content is a matrix with 2 columns
% buffer_content(k,1) (i.e. k-th row, 1st column of buffer_content)
% contains the arrival time of the k-th customer in the buffer
% buffer_content(k,2) (i.e. k-th row, 2nd column of buffer_content)
% contains the service time of the k-th customer in the buffer
% The buffer_content is to imitate a first-come first-serve queue 
% The 1st row has information on the 1st customer in the queue etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Intialise the master clock 
master_clock = 0; 
% 
% Intialise server status
% Indicates the business of each server
server_state = zeros(m,1);
arrival_time_next_departure = zeros(m,1);
% 
% Initialise buffer
buffer_content = [];
queue_length = 0;

% Start iteration until the end time
while (num_customer_served < length(all_arrival_time_file))
    % Find the server with the first departing customer
    [first_departure_time,first_departure_server] = min(next_departure_time);
    [first_setup_time,first_setup_server] = min(next_setup_time);
    [first_expiry_time,first_expiry_server] = min(next_expiry_time);
    next_event_time = min([next_arrival_time, first_departure_time, first_setup_time, first_expiry_time]);
    % 
    %
    % Find the type of next event
    %
    % We use next_event_type = 
    % 0 for departure
    % 1 for arrival
    % 2 for start of server
    % 3 for end of DelayedOff timer
    %
    next_event_is_arrival = 0;
    next_event_is_setup = 0;
    next_event_is_expiry = 0;
    next_event_is_departure = 0;

    if (next_arrival_time == next_event_time)
        next_event_is_arrival = 1; 
    end 
    if (first_setup_time == next_event_time)
        next_event_is_setup = 1;
    end
    if (first_expiry_time == next_event_time)
        next_event_is_expiry = 1;
    end
    if(first_departure_time == next_event_time)
        % first departure server has already been found just now
        next_event_is_departure = 1;
    end
    
    %     
    % update master clock
    % 
    master_clock = next_event_time;
    
    % Checking parameters
    % Uncomment only for debugging
    %status = ['Time ', num2str(master_clock), ' States ', num2str(transpose(server_state)), ' Next Event ',num2str(next_event_is_arrival), num2str(next_event_is_setup), num2str(next_event_is_expiry), num2str(next_event_is_departure), ' Queue Length ',num2str(queue_length)];
    %disp(status);

    %
    % take actions depending on the event type
    % 
    if (next_event_is_arrival == 1) % an arrival 
        % Case when all servers are in Busy or Setup state.
        if (ismember(3,server_state)==0 && ismember(0,server_state)==0)
            % 
            % add customer to buffer_content and
            % increment queue length
            % 
            buffer_content = [buffer_content ; master_clock service_time_next_arrival UNMARKED];
            queue_length = queue_length + 1;        
        
        % Case when there is a server in DelayedOff state.
        elseif ismember(3, server_state)
            idle_server = min(find(next_expiry_time == max(next_expiry_time)));
            next_departure_time(idle_server) = ...
                next_arrival_time + service_time_next_arrival;
            arrival_time_next_departure(idle_server) = next_arrival_time;
            server_state(idle_server) = 2;
            next_expiry_time(idle_server) = nan;
            
        % Else, turn on a new server
        else 
            % 
            % Send the customer to any available server
            % 
            % Schedule departure event with 
            % the departure time is arrival time + service time 
            % Also, set server_state to 1
            % 
            idle_server = min(find(server_state == 0));
            next_setup_time(idle_server) = ...
                next_arrival_time + setup_time;
            
            %arrival_time_next_departure(idle_server) = next_setup_time; %Might need to comment out this one.
            server_state(idle_server) = 1;
            buffer_content = [buffer_content ; master_clock service_time_next_arrival MARKED];
            queue_length = queue_length + 1;        
        end
        % generate a new job and schedule its arrival 
        
        if task_index <= length(all_arrival_time_file)
            next_arrival_time = all_arrival_time_file(task_index);
            service_time_next_arrival = all_service_time_file(task_index);
            task_index = task_index + 1;
        else
            next_arrival_time = Inf;
            service_time_next_arrival = Inf;
        end
        
        % events = [events ; next_arrival_time service_time_next_arrival];
    end
    if (next_event_is_setup == 1) % Server just finished setup
        idle_server = first_setup_server;
        next_departure_time(idle_server) = ...
            master_clock + buffer_content(1,2);
        

        arrival_time_next_departure(idle_server) = ...
            buffer_content(1,1);
        next_setup_time(idle_server) = nan;
        server_state(idle_server) = 2;
        buffer_content(1,:) = [];
        queue_length = queue_length - 1;
    end
    if (next_event_is_expiry == 1) % Expiry of the countdown
        idle_server = first_expiry_server;
        server_state(idle_server) = 0;
        next_expiry_time(idle_server) = nan;
        next_departure_time(idle_server) = Inf;
        next_setup_time(idle_server) = nan;
    end
    if (next_event_is_departure == 1) % a departure 
        % 
        % Update the variables:
        % 1) Cumulative response time T
        % 2) Number of departed customers N
        % 
        all_departure_time = [all_departure_time ; master_clock];
        all_arrival_time = [all_arrival_time ; arrival_time_next_departure(first_departure_server)];
        response_time_cumulative = response_time_cumulative + master_clock - arrival_time_next_departure(first_departure_server);
        num_customer_served = num_customer_served + 1;
        % 
        if queue_length > 0 % buffer not empty
            % 
            % schedule the next departure event using the first customer 
            % in the buffer, i.e. use the 1st row in buffer_content
            % 
            next_departure_time(first_departure_server) = ...
                master_clock + buffer_content(1,2);
            arrival_time_next_departure(first_departure_server) = ...
                buffer_content(1,1);
            % 
            % remove customer from buffer and decrement queue length
            % 
            buffer_content(1,:) = [];
            queue_length = queue_length - 1;
            
            % if there is a server starting
            if ismember(1, server_state)
               if ismember(UNMARKED, buffer_content(:, 3))
                   unmarked_id = findFirstUnmarked(buffer_content);
                   buffer_content(unmarked_id, 3) = MARKED;
               else
                   [setup_time_2, pos] = max(next_setup_time);
                   next_setup_time(pos) = nan;
                   server_state(pos) = 0;
                   next_expiry_time(pos) = nan;
                   next_departure_time(pos) = Inf;
               end
            end
            
        else % buffer empty
            next_departure_time(first_departure_server) = nan;
            server_state(first_departure_server) = 3;
            next_expiry_time(first_departure_server) = master_clock + delayedoff_time;
            next_setup_time(first_departure_server) = nan;
        end    
    end        
end        
    all_arrival_time = all_arrival_time(1 : length(all_departure_time));    
    %avg_response_time = sum(all_departure_time - all_arrival_time) / length(all_arrival_time);
    avg_response_time = response_time_cumulative/num_customer_served;
end


function index = findFirstUnmarked(buffer_content)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Constants
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    UNMARKED = 0;
    
    index = -1;   
    for i = 1 : length(buffer_content)
        if buffer_content(i, 3) == UNMARKED
            index = i;
            break;
        end
    end
end