function r = multiplicative(n)
    % Generate n random integers between 1 and 100 using Multiplicative Congruential Generator
    % seed = initial value (any integer)
    % n = number of random values to generate
    % a = multiplier (16807)  Well-known multiplier
    % m = modulus (2^32-1) Modulus (2^32-1 gives good period length)
 
    a = 16807;        
    m = 2^31 - 1;     
    seed = 5678;       
    
    % Initialize output array
    r = zeros(1, n);
    
    % First value
    r(1) = mod(seed, m);
    
    % Generate sequence
    for i = 2:n
        r(i) = mod(a * r(i-1), m);
    end
    
    % Scale to 1-100 range
    r = 1 + floor((r / m) * 100);
end

% Generate numbers based on input (change 10 to n)
% random_numbers = multiplicative(10);
% disp(random_numbers);