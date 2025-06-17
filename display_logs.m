function display_logs(data)
    for i = 1:size(data, 1)
        vehicle = data{i,2};
        fuel = data{i,3};
        arrive = data{i,8};
        begin = data{i,11};
        finish = data{i,12};
        pump = data{i,15};

        if ~isempty(begin)
            fprintf('Vehicle %d arrived at minute %.2f and began refueling with %s at Pump Island %d.\n', ...
                vehicle, arrive, fuel, pump);
        end
        if ~isempty(finish)
            fprintf('Vehicle %d finished refueling and departed at minute %.2f.\n', vehicle, finish);
        end
    end
end
