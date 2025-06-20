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
    fprintf('Average Time Spent In Ihe System         : %.2f \n', avg_time_spent);
    fprintf('Probability That A Customer Has to Wait  : %.2f \n', probability_wait);
    fprintf('Average Service Time                     : %.2f \n', avg_service_time);      
end
