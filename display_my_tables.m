% display_my_tables.m

clear;
clc;

fprintf('==============================================\n');
fprintf('--- PETROL STATION SIMULATION: INPUT DATA ---\n');
fprintf('==============================================\n\n');

% Data for Table 1: Refueling Time
refuel_Time = [4; 5; 6; 7; 8];
refuel_Prob = [0.10; 0.20; 0.40; 0.20; 0.10];
refuel_CDF = cumsum(refuel_Prob);
refuel_firstNum = [1; 11; 31; 71; 91];
refuel_lastNum = [10; 30; 70; 90; 100];

% Data for Table 2: Type of Petrol
petrol_Names = {'RON95'; 'RON97'; 'Diesel'};
petrol_Prices = [2.05; 3.07; 2.74];
petrol_Prob = [0.5; 0.4; 0.1];
petrol_CDF_Petrol = cumsum(petrol_Prob); 
petrol_firstNum = [1; 51; 91];
petrol_lastNum = [50; 90; 100];

% Data for Table 3: Inter-Arrival Time
inter_Time = [1; 2; 3; 4; 5];
inter_Prob = [0.2; 0.1; 0.2; 0.4; 0.1];
inter_CDF = cumsum(inter_Prob);
inter_firstNum = [1; 21; 31; 51; 91];
inter_lastNum = [20; 30; 50; 90; 100];


%% --- TABLE 1: REFUELING TIME ---

fprintf('--- Time To Fill Up The Petrol ---\n');
fprintf('%-20s %-15s %-10s %-10s\n', 'Refueling Time', 'Probability', 'CDF', 'Range');
fprintf('------------------------------------------------------------------\n');

for i = 1:size(refuel_Time, 1) 
    range_str = sprintf('%d - %d', refuel_firstNum(i), refuel_lastNum(i));
    fprintf('%-20d %-15.2f %-10.2f %-10s\n', refuel_Time(i), refuel_Prob(i), refuel_CDF(i), range_str);
end
fprintf('\n\n'); % Add blank lines for spacing


%% --- TABLE 2: TYPE OF PETROL ---

fprintf('--- Type Of Petrol ---\n');
fprintf('%-15s %-12s %-15s %-10s %-10s\n', 'Petrol Type', 'Price (RM)', 'Probability', 'CDF', 'Range');
fprintf('----------------------------------------------------------------------\n');

for i = 1:size(petrol_Names, 1) 
    range_str = sprintf('%d - %d', petrol_firstNum(i), petrol_lastNum(i));
    fprintf('%-15s %-12.2f %-15.2f %-10.2f %-10s\n', petrol_Names{i}, petrol_Prices(i), petrol_Prob(i), petrol_CDF_Petrol(i), range_str);
end
fprintf('\n\n');


%% --- TABLE 3: INTER-ARRIVAL TIME ---

fprintf('--- Inter-Arrival Time ---\n');
fprintf('%-20s %-15s %-10s %-10s\n', 'Inter-arrival Time', 'Probability', 'CDF', 'Range');
fprintf('------------------------------------------------------------------\n');

for i = 1:size(inter_Time, 1) 
    range_str = sprintf('%d - %d', inter_firstNum(i), inter_lastNum(i));
    fprintf('%-20d %-15.2f %-10.2f %-10s\n', inter_Time(i), inter_Prob(i), inter_CDF(i), range_str);
end