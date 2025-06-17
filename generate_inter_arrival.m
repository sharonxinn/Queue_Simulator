function inter_arrival = generate_inter_arrival(random_num, is_peak)
    % Returns inter-arrival time based on peak/non-peak
    if is_peak
        % Peak hours use 1-50 range
        if random_num <= 20       % 1-20
            inter_arrival = 0;
        elseif random_num <= 30   % 21-30
            inter_arrival = 0.5;
        elseif random_num <= 50   % 31-50
            inter_arrival = 1;
        end
    else
        % Non-peak hours use 51-100 range
        if random_num <= 90       % 51-90 (adjusted for 4% probability)
            inter_arrival = 1.5;
        else                     % 91-100 (adjusted for 6% probability)
            inter_arrival = 2;
        end
    end
end