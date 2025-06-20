function process_and_display(data, label)
    if isempty(data)
        return;
    end
    
    pump_end_times = zeros(1, 4);
    pump_data = cell(size(data,1), 14);

    for i = 1:size(data,1)
        arrival = data{i,8};
        rand_refuel = data{i,9};
        refuel = generate_refuel_time(rand_refuel);
        assigned_pump = 0;

        % Random line assignment
        line_no = floor(1 + rand() * 2);
        data{i,16} = line_no;
        if line_no == 1
            line_pumps = [1, 2];
        else
            line_pumps = [3, 4];
        end

        % Check availability of pumps in that line
        available_pumps = line_pumps(arrival >= pump_end_times(line_pumps));

        if ~isempty(available_pumps)
            assigned_pump = available_pumps(1);  % first free pump
        else
            [dummy, idx] = min(pump_end_times(line_pumps));  % dummy used to avoid FreeMat error
            assigned_pump = line_pumps(idx);
        end

        begin_time = max(arrival, pump_end_times(assigned_pump));
        wait_time = begin_time - arrival;
        end_time = begin_time + refuel;
        time_spent = refuel + wait_time;
        pump_end_times(assigned_pump) = end_time;

        data{i,10} = refuel;
        data{i,11} = begin_time;
        data{i,12} = end_time;
        data{i,13} = wait_time;
        data{i,14} = time_spent;
        data{i,15} = assigned_pump; 

        for p = 1:4
            if p == assigned_pump
                pump_data{i, (p - 1)*3 + 1} = refuel;
                pump_data{i, (p - 1)*3 + 2} = begin_time;
                pump_data{i, (p - 1)*3 + 3} = end_time;
            else
                pump_data{i, (p - 1)*3 + 1} = '-';
                pump_data{i, (p - 1)*3 + 2} = '-';
                pump_data{i, (p - 1)*3 + 3} = '-';
            end
        end
        pump_data{i,13} = wait_time;
        pump_data{i,14} = time_spent;
        
    end
    
    %display logs
    display_logs(data);
    
    
    %display table
    fprintf('\n=== %s ===\n', label);
    fprintf('%-139s| %-100s\n', '', '                    Pump 1:');
    fprintf(['%-10s | %-11s | %-13s | %-17s | %-18s | %-13s | %-13s | %-4s | ', ...
             '%-15s | %-15s | %-12s | %-9s\n'], ...
            'Vehicle No', 'Petrol Type', 'Quantity (L)', 'Total Price (RM)', ...
            'Rand Interarrival', 'Interarrival', 'Arrival Time', 'Line', ...
            'Rand Refueling', 'Refueling Time', 'Time Begins', 'Time Ends');
    fprintf('%s\n', repmat('-', 1, 190));
    
     for i = 1:size(data,1)
        inter_display = '-';
        if i ~= 1
            inter_display = num2str(data{i,7});
        end

        % Only show refuel details in Pump 1 column if assigned to Pump 1
        if data{i,15} == 1
            refuel_str = num2str(data{i,10});
            begin_str = num2str(data{i,11});
            end_str = num2str(data{i,12});
        else
            refuel_str = '-';
            begin_str = '-';
            end_str = '-';
        end       

        fprintf(['%10d | %-11s | %13.2f | %17.2f | %18d | %13s | %13.2f | %4d | ', ...
                 '%15d | %-15s | %-12s | %-9s\n'], ...
                data{i,2}, data{i,3}, data{i,4}, data{i,5}, data{i,6}, inter_display, ...
                data{i,8}, data{i,16}, data{i,9}, refuel_str, begin_str, end_str);
    end

    fprintf('\n\n');
    fprintf('%-16s%-43s|%-43s|%-40s\n', '', '                  Pump 2:', '                  Pump 3:', '                  Pump 4:');
    fprintf(['%-15s| %-15s| %-12s| %-10s | %-15s| %-12s| %-10s | ', ...
             '%-15s| %-12s| %-10s | %-13s| %-12s\n'], ...
            'Vehicle No', 'Refuel Time', 'Time Begin', 'Time End', ...
            'Refuel Time', 'Time Begin', 'Time End', ...
            'Refuel Time', 'Time Begin', 'Time End', 'Waiting Time', 'Time Spent');
    fprintf('%s\n', repmat('-', 1, 180));

    for i = 1:size(pump_data, 1)
        fprintf(['%-15d| %-15s| %-12s| %-10s | %-15s| %-12s| %-10s | ', ...
                 '%-15s| %-12s| %-10s | %-13.2f| %-12.2f\n'], ...
                data{i,2}, ...
                safe_str(pump_data{i,4}), safe_str(pump_data{i,5}), safe_str(pump_data{i,6}), ...
                safe_str(pump_data{i,7}), safe_str(pump_data{i,8}), safe_str(pump_data{i,9}), ...
                safe_str(pump_data{i,10}), safe_str(pump_data{i,11}), safe_str(pump_data{i,12}), ...
                data{i,13}, data{i,14});
    end
    
    
    %calculate the avg
    evaluate_result(data);
end

function s = safe_str(v)
    if isnumeric(v)
        s = num2str(v);
    elseif ischar(v)
        s = v;
    else
        s = '-';
    end
end