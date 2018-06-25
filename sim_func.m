function [all_arrival_time, all_departure_time, avg_response_time] = sim_func(mode, lambda, mu, m, setup_time, delayedoff_time, time_end)

    if strcmp(mode,'trace') == 1
        [all_arrival_time, all_departure_time, avg_response_time] = sim_trace_func(lambda, mu, m, setup_time, delayedoff_time);
    elseif strcmp(mode,'random') == 1
        [all_arrival_time, all_departure_time, avg_response_time] = sim_random_func(lambda, mu, m, setup_time, delayedoff_time, time_end);
    else
        disp("Error: Unknown mode, only random and trace are supported.")
        [all_arrival_time] = ['Error, Unknown mode'];
        [all_departure_time] = ['Error, Unknown mode'];
        [avg_response_time] = ['Error, Unknown mode'];
    end
end
