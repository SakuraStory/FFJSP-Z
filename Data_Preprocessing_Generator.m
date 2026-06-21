clc;
clear;

%% ========================================================================
%  Generator script for reliability-augmented benchmark instances
%
%  This script reads the original benchmark instances and generates the
%  corresponding reliability-augmented instances. Machine categories are
%  assigned according to Table S-II, and reliability levels are assigned
%  according to Table S-I.
%
%  Reproducibility:
%  - Machine category assignment uses seedCategory = baseSeedCategory + i.
%  - Reliability level assignment uses seedReliability = baseSeedReliability + i.
%  - i is the index of the benchmark instance in inputFiles.
%  - The random number generator is initialized with rng(seed, 'twister').
%% ========================================================================

%% Input benchmark instances
inputFiles = {
    'instances1/D01.txt';
    'instances1/D02.txt';
    'instances1/D03.txt';
    'instances1/D04.txt';
    'instances1/D05.txt';
    'instances2/R01.txt';
    'instances2/R02.txt';
    'instances2/R03.txt';
    'instances2/R04.txt';
    'instances2/R05.txt';
    'instances2/R06.txt';
    'instances2/R07.txt';
    'instances2/R08.txt';
    'instances3/FMK01.txt';
    'instances3/FMK02.txt';
    'instances3/FMK03.txt';
    'instances3/FMK04.txt';
    'instances3/FMK05.txt';
    'instances3/FMK06.txt';
    'instances3/FMK07.txt';
    'instances3/FMK08.txt';
    'instances3/FMK09.txt';
    'instances3/FMK10.txt'
};

%% Output folder
outputDir = 'Generated_Reliability_Instances';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Reliability levels from Table S-I
% Format: [b1, b2, b3]
B_Medium   = [0.50, 0.60, 0.70];
B_High     = [0.60, 0.75, 0.90];
B_VeryHigh = [0.80, 0.90, 1.00];
B_Perfect  = [0.90, 1.00, 1.00];

%% Random seeds for reproducibility
baseSeedCategory    = 10000;  % Base seed for assigning machine categories
baseSeedReliability = 20000;  % Base seed for assigning reliability levels
rngType = 'twister';

%% Records for reproducibility
seedRecord = cell(length(inputFiles), 3);
categoryRecord = [];

%% Generate reliability-augmented instances
for i = 1:length(inputFiles)

    %% Read the original instance
    lines = readlines(inputFiles{i});
    rawData = cell(size(lines));

    for j = 1:length(lines)
        rawData{j} = str2num(lines(j)); %#ok<ST2NM>
    end

    %% Extract instance size
    N = rawData{1}(1);  % Number of jobs
    M = rawData{1}(2);  % Number of machines

    %% Set instance-specific random seeds
    seedCategory = baseSeedCategory + i;
    seedReliability = baseSeedReliability + i;

    seedRecord{i, 1} = inputFiles{i};
    seedRecord{i, 2} = seedCategory;
    seedRecord{i, 3} = seedReliability;

    %% Assign machine categories according to Table S-II
    % Category codes:
    % 1: New Machine      (NM), distribution range [VH, P]
    % 2: Standard Machine (SM), distribution range [H, VH]
    % 3: Aged Machine     (AM), distribution range [M, H]
    rng(seedCategory, rngType);

    randOrder = randperm(M);
    numNewMachine = floor(0.20 * M);       % 20% NM
    numStandardMachine = floor(0.50 * M);  % 50% SM
    % The remaining machines are assigned as AM.

    machineCategory = zeros(M, 1);
    machineCategory(randOrder(1:numNewMachine)) = 1;
    machineCategory(randOrder(numNewMachine+1:numNewMachine+numStandardMachine)) = 2;
    machineCategory(randOrder(numNewMachine+numStandardMachine+1:end)) = 3;

    %% Save machine-category assignment records
    for macID = 1:M
        if machineCategory(macID) == 1
            categoryName = 'NM';
        elseif machineCategory(macID) == 2
            categoryName = 'SM';
        else
            categoryName = 'AM';
        end

        categoryRecord = [categoryRecord; {inputFiles{i}, macID, categoryName, seedCategory}]; %#ok<AGROW>
    end

    %% Initialize the RNG for reliability-level assignment
    rng(seedReliability, rngType);

    %% Create output file
    [~, instanceName, ext] = fileparts(inputFiles{i});
    outputFile = fullfile(outputDir, ['Z-', instanceName, ext]);
    fid = fopen(outputFile, 'w');

    if fid == -1
        error('Cannot open output file: %s', outputFile);
    end

    %% Write the header line
    fprintf(fid, '%d %d %d\r\n', rawData{1});

    %% Write operation data with reliability information
    for j = 2:length(rawData)-1

        currentLine = rawData{j};
        numOperations = currentLine(1);
        fprintf(fid, '%d   ', numOperations);

        idx = 2;

        for opID = 1:numOperations

            numAvailableMachines = currentLine(idx);
            fprintf(fid, '%d   ', numAvailableMachines);
            idx = idx + 1;

            for k = 1:numAvailableMachines

                machineID = currentLine(idx);
                category = machineCategory(machineID);
                r = rand();

                %% Assign reliability levels according to machine category
                if category == 1
                    % New Machine: reliability level is VH or P.
                    if r > 0.5
                        reliabilityValue = B_Perfect;
                    else
                        reliabilityValue = B_VeryHigh;
                    end

                elseif category == 2
                    % Standard Machine: reliability level is H or VH.
                    if r > 0.5
                        reliabilityValue = B_VeryHigh;
                    else
                        reliabilityValue = B_High;
                    end

                else
                    % Aged Machine: reliability level is M or H.
                    if r > 0.5
                        reliabilityValue = B_High;
                    else
                        reliabilityValue = B_Medium;
                    end
                end

                %% Write machine information and reliability TFN
                fprintf(fid, '%d %d %d %d ', currentLine(idx:idx+3));
                fprintf(fid, '%.2f %.2f %.2f   ', reliabilityValue);

                idx = idx + 4;
            end
        end

        fprintf(fid, '\r\n');
    end

    fclose(fid);
end

%% Save seed records
seedTable = cell2table(seedRecord, ...
    'VariableNames', {'Instance', 'MachineCategorySeed', 'ReliabilityLevelSeed'});
writetable(seedTable, fullfile(outputDir, 'generator_seeds.csv'));

%% Save machine-category assignment records
categoryTable = cell2table(categoryRecord, ...
    'VariableNames', {'Instance', 'MachineID', 'MachineCategory', 'MachineCategorySeed'});
writetable(categoryTable, fullfile(outputDir, 'machine_category_assignments.csv'));

disp('Reliability-augmented instances have been generated successfully.');
disp(['Output folder: ', outputDir]);
