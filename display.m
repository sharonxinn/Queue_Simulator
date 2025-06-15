function display()
    fprintf('Welcome to the Petrol Station Simulator! \n');
    numVehicles = input('Enter the number of vehicles: ');
    random_nums = 0;
    
    validInput = false;
    while ~validInput
    
        fprintf('There are two random number generator: \n');
        fprintf('1. LCG \n');
        fprintf('2. Multiplicative Distribution \n');
        type_of_generator = input('Enter 1 or 2: ');
    
        if type_of_generator == 1
            random_nums = lcg(3 * numVehicles); % we need generate 3 sets of random number
            validInput = true;
        
        elseif type_of_generator == 2
            random_nums = multiplicative(3 * numVehicles);
            validInput = true;
    
        else
            fprintf('Invalid choice! Please choose 1 or 2 \n');
        
        end
    end 
    
    %prepare an array to store the random number
    interArrival = zeros(1, numVehicles);
    petrolType = zeros(1, numVehicles);
    refuelTime = zeros(1, numVehicles);
    
    for i = 1:numVehicles
        idx = (i - 1) * 3 + 1;
        interArrival(i) = random_nums(idx);  
        petrolType(i) = random_nums(idx + 1);     
        refuelTime(i) = random_nums(idx + 2);      
    end
    
    fprintf('Random number for inter-arrival time: ');
    fprintf('%d  ', interArrival);
    fprintf('\n');

    fprintf('Random number for petrol type       : ');
    fprintf('%d  ', petrolType);
    fprintf('\n');

    fprintf('Random number for refueling time    : ');
    fprintf('%d  ', refuelTime);
    fprintf('\n');
    
    petrolTypeNames = cell(1, numVehicles);
    pricePerLitre = zeros(1, numVehicles);
    litresArray = zeros(1, numVehicles);
    totalPrice = zeros(1, numVehicles);    
    for i = 1:numVehicles
        [ptype, cost] = generate_petrol_type(petrolType(i));
        petrolTypeNames{i} = ptype;
        pricePerLitre(i) = cost;
        litresArray(i) = input(sprintf('Enter the litres for Vehicle # %d (%s): ', i, petrolTypeNames{i}));
        totalPrice(i) = litresArray(i) * pricePerLitre(i); 
    end
    
    fprintf('Price for the petrol    : ');
    fprintf('%.2f  ', totalPrice);
    fprintf('\n');
            
 end
