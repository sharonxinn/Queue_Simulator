function [metrics] = calculate_metrics(simulation_data)
    % Initialize arrays to store metrics for each vehicle
    num_vehicles = size(simulation_data, 1);
    waiting_times = zeros(num_vehicles, 1);
    time_in_system = zeros(num_vehicles, 1);
    had_to_wait = zeros(num_vehicles, 1);
    service_times = zeros(num_vehicles, 1);
    pump_used = zeros(num_vehicles, 1);
    
    % Extract data for each vehicle and calculate metrics
    for i = 1:num_vehicles
        arrival_time = simulation_data(i).arrival_time;
        service_start = simulation_data(i).service_start;
        departure_time = simulation_data(i).departure_time;
        pump_num = simulation_data(i).pump_num;
        
        % Calculate waiting time (0 if no waiting)
        waiting_times(i) = max(0, service_start - arrival_time);
        
        % Flag if vehicle had to wait
        had_to_wait(i) = (waiting_times(i) > 0);
        
        % Calculate total time in system
        time_in_system(i) = departure_time - arrival_time;
        
        % Calculate service time
        service_times(i) = departure_time - service_start;
        
        % Record which pump was used
        pump_used(i) = pump_num;
    end
    
    % Calculate the metrics
    % 1. Average Waiting Time (only for vehicles that waited)
    avg_wait_time = mean(waiting_times(had_to_wait == 1));
    
    % 2. Average Time Spent in System
    avg_system_time = mean(time_in_system);
    
    % 3. Probability That a Customer Has To Wait
    prob_wait = sum(had_to_wait) / num_vehicles;
    
    % 4. Average Service Time at Each Counter (for pumps 1-4)
    avg_service_per_pump = zeros(4, 1);
    for pump = 1:4
        pump_services = service_times(pump_used == pump);
        if ~isempty(pump_services)
            avg_service_per_pump(pump) = mean(pump_services);
        end
    end
    
    % Package all metrics in a structure
    metrics = struct(...
        'avg_wait_time', avg_wait_time, ...
        'avg_system_time', avg_system_time, ...
        'prob_wait', prob_wait, ...
        'avg_service_per_pump', avg_service_per_pump ...
    );
end