function display()
    fprintf('+-----------------------------------------------------------------+\n');
    fprintf('|                                                                 |\n');
    fprintf('|      W E L C O M E   T O   P E T R O N A S   S T A T I O N      |\n');
    fprintf('|                                                                 |\n');
    fprintf('|                      .----------------.                         |\n');
    fprintf('|                     /                  \                        |\n');
    fprintf('|                    |   [------------]   |                       |\n');
    fprintf('|                    |   [  RM 0.00   ]   |                       |\n');
    fprintf('|                    |   [ LITRE 0.00 ]   |                       |\n');
    fprintf('|                    |   [------------]   |                       |\n');
    fprintf('|                    |                    |                       |\n');
    fprintf('|                    |     [1] [2] [3]    |                       |\n');
    fprintf('|                    |     [4] [5] [6]    |                       |\n');
    fprintf('|                    |     [7] [8] [9]    |                       |\n');
    fprintf('|                    |     [  CLEAR  ]    |                       |\n');
    fprintf('|                    `--------------------;                       |\n');
    fprintf('|                                                                 |\n');
    fprintf('+-----------------------------------------------------------------+\n\n');
    fprintf('Below are the table for the time to fill up the petrol, type of petrol and inter- arrival time\n');
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

    % Prepare array to store the random numbers
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
    
    % Calculate the total price of petrol 
    petrolTypeNames = cell(1, numVehicles);
    pricePerLitre = zeros(1, numVehicles);
    litresArray = zeros(1, numVehicles);
    totalPrice = zeros(1, numVehicles);
    
    % Initialized inter_arrival times, arrival times, peak flag
    inter_arrival_times = zeros(1, numVehicles);
    arrival_times = zeros(1, numVehicles);
    is_peak_flags = zeros(1, numVehicles);

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
    end

    % Split data into peak and non-peak
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

    % Call processor
    fprintf('\n====== Peak Hours Log Simulation ====== \n');
    process_and_display(peak_data, 'Peak Hour Vehicles (Random 1 to 50)');
    
   
    fprintf('\n====== Non-Peak Hours Log Simulation ====== \n');
    process_and_display(nonpeak_data, 'Non-Peak Hour Vehicles (Random 51 to 100)');
    
end
