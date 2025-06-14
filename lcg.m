function r = lcg(n)
    % Generate n random integers between 1 and 100 using LCG
    % seed = initial value (any integer)
    % n = number of random values to generate
    % a = multiplier (1664525)  Multiplier (from Numerical Recipes)
    % c = increment (1013904223) Increment
    % m = modulus (2^32) Modulus (2^32 gives good period length)
    
    a = 1664525;      
    c = 1013904223;   
    m = 2^32;         
    seed = 1234;
    
    r = zeros(1, n);
    r(1) = mod(seed, m);
    
    for i = 2:n
        r(i) = mod(a * r(i-1) + c, m);
    end
    
    % Scale to 1-100 range
    r = 1 + floor((r / m) * 100);
end


% Generate numbers based on input (change 10 to n)
% random_numbers = lcg(10);
% disp(random_numbers);