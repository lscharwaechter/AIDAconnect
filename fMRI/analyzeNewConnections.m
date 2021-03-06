function analyzeNewConnections(inputFMRI, graphCell, selectedRegion, day1, day2)

%% analyzeNewConnections
% This function displays connections of a certain region that are not
% present in the first time point but do have a connection weight in the
% second time point. You can specify a weighting threshold to neglect
% new connections with small weights in line 17. In case of rsfMRI, 
% the connection weight is built up of correlations (0-1).

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% selectedRegion = Region to examine (as String)
% day1 = Name of the first day as in inputFMRI.days (as String)
% day2 = Name of the second day as in inputFMRI.days (as String)

%% Specifications
threshold = 0; 

%% Example
% analyzeNewConnections(inputFMRI, graphCell, "L SSp-ll", "Baseline", "P7")

%% Do not modify the following lines

load('../Tools/infoData/acronyms_splitted.mat');

% Convert days to the index number of inputFMRI
dayI = find(inputFMRI.days == day1);
dayII = find(inputFMRI.days == day2);

% Get all new connections for all groups
for group_id = 1:size(inputFMRI.groups,2)
    % Get the row ID in graphCell of the region, for both days I and II
    regionIndexI = find(strcmp(graphCell{group_id,dayI}.Nodes.Name,selectedRegion));
    regionIndexII = find(strcmp(graphCell{group_id,dayII}.Nodes.Name,selectedRegion));
    % Get all connections from that region via ID and calculate the mean over
    % all subjects (3rd dimension)
    allConnectionsI = mean(graphCell{group_id,dayI}.Nodes(regionIndexI,"allMatrix").allMatrix,3);
    allConnectionsII = mean(graphCell{group_id,dayII}.Nodes(regionIndexII,"allMatrix").allMatrix,3);
    % allConnections now is a 1xN double array (N = all possible regions,
    % default 98).
    % Find all non-existing connections at the first day
    zeroIndices = find(allConnectionsI==0);
    % Regarding these connections only, find all that became existent at 
    % the second day:
    % nonZeroLogical returns a list of logical expressions (1/0) for all 
    % given non-existing connections from zeroIndices that have changed to 
    % be existent (not equals 0 anymore). nonZeroIndices then returns 
    % all connections from zeroIndices using this list of logical 
    % expressions
    nonZeroLogical = allConnectionsII(zeroIndices)~=0;
    nonZeroIndices = zeroIndices(nonZeroLogical);
    nonZeroIndicesWeight = allConnectionsII(nonZeroIndices);   
    % greaterThanThreshold contains the index positions of weights greater
    % than a threshold within the list nonZeroIndicesWeight. 
    % To get the actual list of region indices, the list nonZeroIndices
    % needs to be filtered using these positions.
    greaterThanThreshold = find(nonZeroIndicesWeight>threshold);
    greaterThanThresholdIndices = nonZeroIndices(greaterThanThreshold);
    greaterThanThresholdWeights = round(allConnectionsII(greaterThanThresholdIndices),3);
    nonZeroIndicesNames = strings(1,size(greaterThanThresholdIndices,2));
    % Convert the region indices to the region names
    for i = 1:size(greaterThanThresholdIndices,2)
        nonZeroIndicesNames(i) = graphCell{group_id,dayII}.Nodes(greaterThanThresholdIndices(i),"Name").Name{1};
    end
    % Create a table to display the regions and weights per group
    groupTable = table(nonZeroIndicesNames(:), greaterThanThresholdWeights(:));
    groupTable.Properties.VariableNames = {'To Region', 'Connection Weight'};
    disp('New connections of '+string(selectedRegion)+' in group '+inputFMRI.groups(group_id)+' from '+day1+' to '+day2+':');
    if size(groupTable,1) > 0
        disp(groupTable);
    else
        disp('- not existing -')
    end
end
