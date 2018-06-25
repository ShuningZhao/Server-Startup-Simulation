num_tests = importdata('num_tests.txt');

for test_index = 1 : num_tests
    mode_file = ['mode_', num2str(test_index), '.txt'];
    para_file = ['para_' , num2str(test_index) , '.txt'];
    arrival_file = ['arrival_' , num2str(test_index) , '.txt'];
    service_file = ['service_' , num2str(test_index) , '.txt'];
    mrt_file = ['mrt_' , num2str(test_index) , '.txt'];
    departure_file = ['departure_' , num2str(test_index) , '.txt'];

    mode = importdata(mode_file);
    if strcmp(mode{1}, 'trace') == 1
        params = importdata(para_file);
        m = params(1);
        setup_time = params(2);
        delayedoff_time = params(3);
        [all_arrival_time, all_departure_time, avg_response_time] = sim_func(mode{1}, arrival_file, service_file, m, setup_time, delayedoff_time);
        write_result(departure_file, mrt_file, all_arrival_time, all_departure_time, avg_response_time);
    elseif strcmp(mode{1}, 'random') == 1
        params = importdata(para_file);
        arrival = importdata(arrival_file);
        service = importdata(service_file);
        lambda = arrival(1);
        mu = service(1);
        m = params(1);
        setup_time = params(2);
        delayedoff_time = params(3);
        time_end = params(4);
        [all_arrival_time, all_departure_time, avg_response_time] = sim_func(mode{1}, lambda, mu, m, setup_time, delayedoff_time, time_end);
        write_result(departure_file, mrt_file, all_arrival_time, all_departure_time, avg_response_time);
    else
        disp("Error: Unknown mode, only random and trace are supported.")
    end
end


%[arrival, departure, mrt] = sim_trace_func(3, 5, 10, 'arrival_2.txt', 'service_2.txt');
%write_result('', '', arrival, departure, mrt);

function write_result(departure_file, mrt_file, arrival, departure, mrt)
    file = fopen(departure_file, 'w');
    for t = 1 : length(departure)
        fprintf(file, '%.3f\t %.3f\n', arrival(t), departure(t));
    end
    fclose(file);

    file = fopen(mrt_file, 'w');
    fprintf(file, '%.3f', mrt);
    fclose(file);
end