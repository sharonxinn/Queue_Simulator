function setup_and_display_tables()
    % This function creates data and displays it

    % --- new header ---
    fprintf('+-----------------------------------------------------------------+\n');
    fprintf('|                                                                 |\n');
    fprintf('|      W E L C O M E   T O   P E T R O N A S   S T A T I O N      |\n');
    fprintf('|                                                                 |\n');
    fprintf('|                      .------------------.                       |\n');
    fprintf('|                     /                  \                        |\n');
    fprintf('|                    |   [------------]   |                       |\n');
    fprintf('|                    |   [  RM 0.00   ]   |                       |\n');
    fprintf('|                    |   [ LITRE 0.00 ]   |                       |\n');
    fprintf('|                    |   [------------]   |                       |\n');
    fprintf('|                    |                    |                       |\n');
    fprintf('|                    |     [1] [2] [3]    |                       |\n');
    fprintf('|                    |     [4] [5] [6]    |                       |\n');
    fprintf('|                    |     [7] [8] [9]    |                       |\n');
    fprintf('|                    |     [  CLEAR  ]    |                       |\n');
    fprintf('|                    `--------------------;                       |\n');
    fprintf('|                                                                 |\n');
    fprintf('+-----------------------------------------------------------------+\n\n');


    % --- Create all the data and store it in a struct ---
    sim_data = struct();

    % Refueling Time Data
    sim_data.refuel.Time = [5; 6; 7; 8; 9];
    sim_data.refuel.Prob = [0.10; 0.20; 0.40; 0.20; 0.10];
    sim_data.refuel.CDF = cumsum(sim_data.refuel.Prob);
    sim_data.refuel.firstNum = [1; 11; 31; 71; 91];
    sim_data.refuel.lastNum = [10; 30; 70; 90; 100];

    % Petrol Type Data
    sim_data.petrol.Names = {'RON95'; 'RON97'; 'Diesel'};
    sim_data.petrol.Prices = [2.05; 3.07; 2.74];
    sim_data.petrol.Prob = [0.5; 0.4; 0.1];
    sim_data.petrol.CDF = cumsum(sim_data.petrol.Prob);
    sim_data.petrol.firstNum = [1; 51; 91];
    sim_data.petrol.lastNum = [50; 90; 100];

    % Inter-Arrival Time Data
    sim_data.inter.Time = [0; 0.5; 1; 1.5; 2];
    sim_data.inter.Prob = [0.2; 0.1; 0.2; 0.4; 0.1];
    sim_data.inter.CDF = cumsum(sim_data.inter.Prob);
    sim_data.inter.firstNum = [1; 21; 31; 51; 91];
    sim_data.inter.lastNum = [20; 30; 50; 90; 100];

    % Display Table 1
    fprintf('--- Time To Fill Up The Petrol ---\n');
    fprintf('+--------------------+---------------+----------+------------+\n');
    fprintf('| %-18s | %-13s | %-8s | %-10s |\n', 'Refueling Time', 'Probability', 'CDF', 'Range');
    fprintf('+--------------------+---------------+----------+------------+\n');
    for i = 1:size(sim_data.refuel.Time, 1)
        range_str = sprintf('%d - %d', sim_data.refuel.firstNum(i), sim_data.refuel.lastNum(i));
        fprintf('| %-18d | %-13.2f | %-8.2f | %-10s |\n', sim_data.refuel.Time(i), sim_data.refuel.Prob(i), sim_data.refuel.CDF(i), range_str);
    end
    fprintf('+--------------------+---------------+----------+------------+\n\n\n');

    % Display Table 2
    fprintf('--- Type Of Petrol ---\n');
    fprintf('+---------------+--------------+---------------+----------+------------+\n');
    fprintf('| %-13s | %-12s | %-13s | %-8s | %-10s |\n', 'Petrol Type', 'Price (RM)', 'Probability', 'CDF', 'Range');
    fprintf('+---------------+--------------+---------------+----------+------------+\n');
    for i = 1:size(sim_data.petrol.Names, 1)
        range_str = sprintf('%d - %d', sim_data.petrol.firstNum(i), sim_data.petrol.lastNum(i));
        fprintf('| %-13s | %-12.2f | %-13.2f | %-8.2f | %-10s |\n', sim_data.petrol.Names{i}, sim_data.petrol.Prices(i), sim_data.petrol.Prob(i), sim_data.petrol.CDF(i), range_str);
    end
    fprintf('+---------------+--------------+---------------+----------+------------+\n\n\n');

    % Display Table 3
    fprintf('--- Inter-Arrival Time ---\n');
    fprintf('+--------------------+---------------+----------+------------+\n');
    fprintf('| %-18s | %-13s | %-8s | %-10s |\n', 'Inter-arrival Time', 'Probability', 'CDF', 'Range');
    fprintf('+--------------------+---------------+----------+------------+\n');
    for i = 1:size(sim_data.inter.Time, 1)
        range_str = sprintf('%d - %d', sim_data.inter.firstNum(i), sim_data.inter.lastNum(i));
        fprintf('| %-18.1f | %-13.2f | %-8.2f | %-10s |\n', sim_data.inter.Time(i), sim_data.inter.Prob(i), sim_data.inter.CDF(i), range_str);
    end
    fprintf('+--------------------+---------------+----------+------------+\n');

end