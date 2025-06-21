function evaluate_result(data)
    total_waiting_time = 0;
    total_cars = size(data, 1);
    total_time_spend = 0;
    total_refuel_time = 0;
    waiting_customers = 0;
    
    for i = 1:size(data, 1)
        total_waiting_time = total_waiting_time + data{i,13};
        total_time_spend = total_time_spend + data{i,14};
        total_refuel_time = total_refuel_time + data{i,10};
        if data{i,13} > 0
            waiting_customers = waiting_customers + 1;
        end 
    end
    avg_waiting_time = total_waiting_time / total_cars;
    avg_time_spent = total_time_spend / total_cars;
    avg_service_time = total_refuel_time / total_cars;
    probability_wait = waiting_customers / total_cars;
   
    fprintf('\n====== Result evaluation ======\n');    
    fprintf('Average Waiting Time                     : %.2f \n', avg_waiting_time);
    fprintf('Average Time Spent In The System         : %.2f \n', avg_time_spent);
    fprintf('Probability That A Customer Has to Wait  : %.2f \n', probability_wait);
    fprintf('Average Service Time                     : %.2f \n', avg_service_time);

    fprintf('Would you like to see the graph of waiting vs not waiting Customer? \n');
    user_choice = input('Enter your choice (y/n): ', 's');
    if lower(user_choice) == 'y';
        % Count who waited
        no_waiting = total_cars - waiting_customers;

        x = [1, 2];             % X positions: 1 = No Wait, 2 = Waited
        y = [no_waiting, waiting_customers];  % Y values: counts

        % Plotting simulated bar
        figure;
        %plot([x1, y1], [x2, y2])
        plot([1 1], [0 y(1)], 'b', 'LineWidth', 10); hold on;
        plot([2 2], [0 y(2)], 'g', 'LineWidth', 10);

        % Set axis limits and labels
        xlim([0 3]);
        ylim([0 max(y) + 1]);

        xlabel('Waiting Status');
        ylabel('Number of Cars');
        title('Cars That Did Not Wait (1) vs  Waited (2)');
        grid on;

    end

end