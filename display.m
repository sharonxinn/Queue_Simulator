function display()
    fprintf('Welcome to the Petrol Station Simulator!\n');
    fprintf('Below are the table for the time to fill up the petrol, type of petrol and inter-arrival time\n');
    setup_and_display_tables;
    fprintf('\n \n ');
    numVehicles = input('Enter the number of vehicles: ');
    random_nums = 0;

    % Random number generator selection
    validInput = false;
    while ~validInput
        fprintf('There are two random number generators: \n');
        fprintf('1. LCG \n');
        fprintf('2. Multiplicative Distribution \n');
        type_of_generator = input('Enter 1 or 2: ');

        if type_of_generator == 1
            random_nums = lcg(3 * numVehicles);
            validInput = true;
        elseif type_of_generator == 2
            random_nums = multiplicative(3 * numVehicles);
            validInput = true;
        else
            fprintf('Invalid choice! Please choose 1 or 2 \n');
        end
    end

    % Parse random numbers
    interArrival = zeros(1, numVehicles);
    petrolTypeRand = zeros(1, numVehicles);
    refuelTimeRand = zeros(1, numVehicles);

    for i = 1:numVehicles
        idx = (i - 1) * 3 + 1;
        interArrival(i) = random_nums(idx);
        petrolTypeRand(i) = random_nums(idx + 1);
        refuelTimeRand(i) = random_nums(idx + 2);
    end

    % Display generated random numbers
    fprintf('\n');
    fprintf('Random number for inter-arrival time: ');
    fprintf('%d  ', interArrival);
    fprintf('\n');

    fprintf('Random number for petrol type       : ');
    fprintf('%d  ', petrolTypeRand);
    fprintf('\n');

    fprintf('Random number for refueling time    : ');
    fprintf('%d  ', refuelTimeRand);
    fprintf('\n');
    
    % Initialize data storage
    petrolTypeNames = cell(1, numVehicles);
    pricePerLitre = zeros(1, numVehicles);
    litresArray = zeros(1, numVehicles);
    totalPrice = zeros(1, numVehicles);
    arrival_times = zeros(1, numVehicles);
    service_starts = zeros(1, numVehicles);
    departure_times = zeros(1, numVehicles);
    pump_numbers = zeros(1, numVehicles);
    is_peak_flags = zeros(1, numVehicles);
    waiting_times = zeros(1, numVehicles);
    
    % Track pump availability (initially all available at time 0)
    pump_available = zeros(1, 4);
    
    % Initialize peak/non-peak counters
    peak_arrival = 0;
    nonpeak_arrival = 0;
    peak_first = true;
    nonpeak_first = true;
    
    fprintf('\n');
    for i = 1:numVehicles
        % Petrol type
        [ptype, cost] = generate_petrol_type(petrolTypeRand(i));
        petrolTypeNames{i} = ptype;
        pricePerLitre(i) = cost;
        litresArray(i) = input(sprintf('Enter the litres for Vehicle #%d (%s): ', i, petrolTypeNames{i}));
        totalPrice(i) = litresArray(i) * pricePerLitre(i);

        % Arrival time logic
        rand_inter = interArrival(i);
        is_peak = rand_inter <= 50;
        is_peak_flags(i) = is_peak;
        inter_time = generate_inter_arrival(rand_inter, is_peak);
        inter_arrival_times(i) = inter_time;

        if is_peak
            if peak_first
                arrival_times(i) = 0;
                peak_first = false;
            else
                arrival_times(i) = peak_arrival + inter_time;
            end
            peak_arrival = arrival_times(i);
        else
            if nonpeak_first
                arrival_times(i) = 0;
                nonpeak_first = false;
            else
                arrival_times(i) = nonpeak_arrival + inter_time;
            end
            nonpeak_arrival = arrival_times(i);
        end
        
        % Determine pump assignment based on availability
        [pump_num, service_start] = assign_pump(arrival_times(i), pump_available);
        pump_numbers(i) = pump_num;
        
        % Calculate refuel time and departure time
        refuel_time = generate_refuel_time(refuelTimeRand(i));
        departure_times(i) = service_start + refuel_time;
        
        % Update pump availability
        pump_available(pump_num) = departure_times(i);
        
        % Calculate waiting time
        waiting_times(i) = service_start - arrival_times(i);
        service_starts(i) = service_start;
        
        % Debug output
        fprintf('Vehicle %d: Arrives=%.1f, Pump=%d, ServiceStart=%.1f, Departs=%.1f, Waits=%.1f\n', ...
                i, arrival_times(i), pump_num, service_start, departure_times(i), waiting_times(i));
    end

    % Create simulation data structure
    simulation_data = struct();
    for i = 1:numVehicles
        simulation_data(i).vehicle_no = i;
        simulation_data(i).arrival_time = arrival_times(i);
        simulation_data(i).service_start = service_starts(i);
        simulation_data(i).departure_time = departure_times(i);
        simulation_data(i).pump_num = pump_numbers(i);
        simulation_data(i).waiting_time = waiting_times(i);
        simulation_data(i).petrol_type = petrolTypeNames{i};
        simulation_data(i).litres = litresArray(i);
        simulation_data(i).total_price = totalPrice(i);
        simulation_data(i).is_peak = is_peak_flags(i);
    end

    % Split data for display
    peak_data = {};
    nonpeak_data = {};
    for i = 1:numVehicles
        row = {'', i, petrolTypeNames{i}, litresArray(i), totalPrice(i), ...
               interArrival(i), inter_arrival_times(i), arrival_times(i), refuelTimeRand(i)};
        if is_peak_flags(i)
            peak_data = [peak_data; row];
        else
            nonpeak_data = [nonpeak_data; row];
        end
    end

    % Display logs
    fprintf('\n====== Peak Hours Log Simulation ====== \n');
    process_and_display(peak_data, 'Peak Hour Vehicles (Random 1 to 50)');
    
    fprintf('\n====== Non-Peak Hours Log Simulation ====== \n');
    process_and_display(nonpeak_data, 'Non-Peak Hour Vehicles (Random 51 to 100)');
    
    % Calculate metrics with verification
    metrics = calculate_metrics(simulation_data);

    % Display results
    fprintf('\n=== Simulation Results ===\n');
    fprintf('Average Waiting Time: %.2f minutes\n', metrics.avg_wait_time);
    fprintf('Average Time in System: %.2f minutes\n', metrics.avg_system_time);
    fprintf('Probability of Waiting: %.1f%%\n', metrics.prob_wait * 100);
    fprintf('\nAverage Service Time per Pump:\n');
    for pump = 1:4
        fprintf('  Pump %d: %.2f minutes\n', pump, metrics.avg_service_per_pump(pump));
    end
    
    % Verification output
    fprintf('\n=== Verification Metrics ===\n');
    fprintf('Total waiting time: %.2f minutes (from %d waiting vehicles)\n', ...
            sum(waiting_times(waiting_times>0)), sum(waiting_times>0));
    fprintf('Total system time: %.2f minutes\n', sum(departure_times - arrival_times));
    for pump = 1:4
        pump_services = departure_times(pump_numbers==pump) - service_starts(pump_numbers==pump);
        fprintf('Pump %d services: ', pump);
        fprintf('%.1f ', pump_services);
        fprintf('\n');
    end
end

function [pump_num, service_start] = assign_pump(arrival_time, pump_available)
    % Find first available pump
    available_pumps = find(pump_available <= arrival_time);
    
    if ~isempty(available_pumps)
        % Choose the first available pump
        pump_num = available_pumps(1);
        service_start = arrival_time;
    else
        % All pumps busy, choose the one that becomes available first
        [service_start, pump_num] = min(pump_available);
    end
end

function metrics = calculate_metrics(simulation_data)
    num_vehicles = length(simulation_data);
    waiting_times = zeros(num_vehicles, 1);
    time_in_system = zeros(num_vehicles, 1);
    had_to_wait = zeros(num_vehicles, 1);
    service_times = zeros(num_vehicles, 1);
    pump_used = zeros(num_vehicles, 1);
    
    for i = 1:num_vehicles
        waiting_times(i) = simulation_data(i).waiting_time;
        had_to_wait(i) = (waiting_times(i) > 0);
        time_in_system(i) = simulation_data(i).departure_time - simulation_data(i).arrival_time;
        service_times(i) = simulation_data(i).departure_time - simulation_data(i).service_start;
        pump_used(i) = simulation_data(i).pump_num;
    end
    
    % Calculate metrics with proper verification
    if any(had_to_wait)
        avg_wait_time = mean(waiting_times(had_to_wait == 1));
    else
        avg_wait_time = 0;
    end
    
    avg_system_time = mean(time_in_system);
    prob_wait = sum(had_to_wait) / num_vehicles;
    
    % Calculate pump service times more carefully
    avg_service_per_pump = zeros(4, 1);
    pump_counts = zeros(4, 1);
    for i = 1:num_vehicles
        pump = pump_used(i);
        pump_counts(pump) = pump_counts(pump) + 1;
        avg_service_per_pump(pump) = avg_service_per_pump(pump) + service_times(i);
    end
    
    for pump = 1:4
        if pump_counts(pump) > 0
            avg_service_per_pump(pump) = avg_service_per_pump(pump) / pump_counts(pump);
        end
    end
    
    metrics = struct(...
        'avg_wait_time', avg_wait_time, ...
        'avg_system_time', avg_system_time, ...
        'prob_wait', prob_wait, ...
        'avg_service_per_pump', avg_service_per_pump, ...
        'pump_counts', pump_counts ...
    );
end