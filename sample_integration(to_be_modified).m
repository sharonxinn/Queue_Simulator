% Initialize
num_vehicles = 100;
is_peak = true; % Change to false for non-peak hours

% Generate all random numbers at once
random_nums = multiplicative_1_100(3 * num_vehicles); % Generate extra numbers

% Simulation loop
for i = 1:num_vehicles
    % Get the next 3 random numbers
    idx = (i-1)*3 + 1;
    rand1 = random_nums(idx);   % For inter-arrival
    rand2 = random_nums(idx+1); % For petrol type
    rand3 = random_nums(idx+2); % For refuel time
    
    % Determine time characteristics
    inter_arrival_time = generate_inter_arrival(rand1, is_peak);
    [petrol_type, price_per_liter] = generate_petrol_type(rand2);
    refuel_time = generate_refuel_time(rand3);
    
    % Calculate quantity (random 20-50 liters)
    quantity = 20 + mod(rand1, 31); % 20-50
    
    % Store or process this vehicle's data
    % ... (your code here)
    
    % Display info (optional)
    fprintf('Vehicle %d: Arrives after %d min, %s, %d liters, refuels for %d min\n', ...
            i, inter_arrival_time, petrol_type, quantity, refuel_time);
end