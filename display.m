function display()
    fprintf('Welcome to the Petrol Station Simulator! \n');
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

    fprintf('Random number for inter-arrival time: ');
    fprintf('%d  ', interArrival);
    fprintf('\n');

    fprintf('Random number for petrol type       : ');
    fprintf('%d  ', petrolTypeRand);
    fprintf('\n');

    fprintf('Random number for refueling time    : ');
    fprintf('%d  ', refuelTimeRand);
    fprintf('\n');

    petrolTypeNames = cell(1, numVehicles);
    pricePerLitre = zeros(1, numVehicles);
    litresArray = zeros(1, numVehicles);
    totalPrice = zeros(1, numVehicles);
    inter_arrival_times = zeros(1, numVehicles);
    arrival_times = zeros(1, numVehicles);
    is_peak_flags = zeros(1, numVehicles);

    % Initialize peak/non-peak counters
    peak_arrival = 0;
    nonpeak_arrival = 0;
    peak_first = true;
    nonpeak_first = true;

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

    % Split data
    peak_data = [];
    nonpeak_data = [];
    for i = 1:numVehicles
        row = {i, petrolTypeNames{i}, litresArray(i), totalPrice(i), ...
               interArrival(i), inter_arrival_times(i), arrival_times(i)};
        if is_peak_flags(i)
            peak_data = [peak_data; row];
        else
            nonpeak_data = [nonpeak_data; row];
        end
    end

    % Display Peak
    if ~isempty(peak_data)
        fprintf('\n=== Peak Hour Vehicles (Random 1 to 50) ===\n');
        fprintf('Vehicle Number | Type of Petrol | Quantity (L) | Total Price (RM) | Rand Interarrival | Interarrival | Arrival Time\n');
        fprintf('-----------------------------------------------------------------------------------------------------------------------\n');
        for i = 1:size(peak_data, 1)
            vehicle_number = peak_data{i, 1};
            inter_display = '-';
            if i ~= 1
                inter_display = num2str(peak_data{i, 6});
            end
            fprintf('%-14d | %-14s | %-12.2f | %-16.2f | %-17d | %-13s | %-12d\n', ...
                vehicle_number, peak_data{i, 2}, peak_data{i, 3}, peak_data{i, 4}, ...
                peak_data{i, 5}, inter_display, peak_data{i, 7});
        end
    end

    % Display Non-Peak
    if ~isempty(nonpeak_data)
        fprintf('\n=== Non-Peak Hour Vehicles (Random 51 to 100) ===\n');
        fprintf('Vehicle Number | Type of Petrol | Quantity (L) | Total Price (RM) | Rand Interarrival | Interarrival | Arrival Time\n');
        fprintf('-----------------------------------------------------------------------------------------------------------------------\n');
        for i = 1:size(nonpeak_data, 1)
            vehicle_number = nonpeak_data{i, 1};
            inter_display = '-';
            if i ~= 1
                inter_display = num2str(nonpeak_data{i, 6});
            end
            fprintf('%-14d | %-14s | %-12.2f | %-16.2f | %-17d | %-13s | %-12d\n', ...
                vehicle_number, nonpeak_data{i, 2}, nonpeak_data{i, 3}, nonpeak_data{i, 4}, ...
                nonpeak_data{i, 5}, inter_display, nonpeak_data{i, 7});
        end
    end
end
