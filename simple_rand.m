function r = simple_rand(n)
    % Generate n random integers between 1 and 100
    % Uses FreeMat's built-in rand()
    r = 1 + floor(rand(1, n) * 100);
end

% Generate numbers based on input (change 10 to n)
% random_numbers = simple_rand(10);
% disp(random_numbers);