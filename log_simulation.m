function log_simulation()
    fprintf('\n=== %s: Simulation Log ===\n', label);
    n = size(data, 1);
    
    for i = 1:n

        
        fprintf('Vehicle %d arrived at minute %d and began refueling with %s at Pump Island %d.\n', ...
                vehicleNo, arrivalTime, petrolType, pumpNum);
        
        fprintf('Vehicle %d finished refueling and departed at minute %d.\n\n', ...
                vehicleNo, endTime);
    end
end
