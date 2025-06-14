function refuel_time = generate_refuel_time(random_num)
    % Returns refuel time based on probability table
    if random_num <= 10       % 1-10
        refuel_time = 4;
    elseif random_num <= 30   % 11-30
        refuel_time = 5;
    elseif random_num <= 70   % 31-70
        refuel_time = 6;
    elseif random_num <= 90   % 71-90
        refuel_time = 7;
    else                      % 91-100
        refuel_time = 8;
    end
end