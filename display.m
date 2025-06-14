function display()
    fprintf('Welcome to the Petrol Station Simulator! \n');
    numVechicles = input('Enter the number of vehicles: ');
    random_nums = 0;
    
    fprintf('There are two random number generator: \n');
    fprintf('1. LCG \n');
    fprintf('2. Multiplicative Distribution \n');
    type_of_generator = input('Enter 1 or 2: ');
    if type_of_generator == 1
        random_nums = lcg(3 * numVechicles);
        
    elseif type_of_generator == 2
        random_nums = multiplicative(3 * numVechicles);
    end
           
    fprintf('Random number for inter-arrival time: ');
    for i=1:numVechicles
        idx = (i-1)*3 + 1;
        rand1 = random_nums(idx);   % For inter-arrival
        fprintf('%d  ', rand1);
    end
    fprintf('\n');
    
    fprintf('Random number for petrol type       : ');
    for i=1:numVechicles
        idx = (i-1)*3 + 1;
        rand2 = random_nums(idx+1); % For petrol type
        fprintf('%d  ', rand2);
    end
    fprintf('\n');
    
    fprintf('Random number for refueling time    : ');
    for i=1:numVechicles
        idx = (i-1)*3 + 1;
        rand3 = random_nums(idx+2); % For refuel time
        fprintf('%d  ', rand3);        
    end
    fprintf('\n');
 end