function [petrol_type, price] = generate_petrol_type(random_num)
    % Returns petrol type and price/liter
    if random_num <= 50       % 1-50 (RON95)
        petrol_type = 'RON95';
        price = 2.05;
    elseif random_num <= 90   % 51-90 (RON97)
        petrol_type = 'RON97';
        price = 3.07;
    else                      % 91-100 (Diesel)
        petrol_type = 'Diesel';
        price = 2.74;
    end
end