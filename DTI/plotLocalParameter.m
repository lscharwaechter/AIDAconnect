function plotLocalParameter(inputDTI, graphCell, strNodeName, strParameter)

%% plotLocalParameter
% Displays local graph properties of a region for two groups

% Input Arguments
% inputDTI and graphCell from mergeDTIdata_input.m
% strNodeName = Region to examine (as String)
% strParameter = 'Degree', 'Eigenvector', 'Betweenness', 'Strength', 
%                'Clustercoefficient', 'Efficiency',
%                'FA0', 'AD', 'MD', 'RD'

%% Example
% plotLocalParameter(inputDTI, graphCell, 'L SSp-ul', 'Degree') 

%% Do not modify the following lines

days = inputDTI.days;
groups = inputDTI.groups;
numOfDays = size(inputDTI.days,2);
numOfGroups = size(inputDTI.groups,2);
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;
[~,b] = ismember(strNodeName,acronyms);
addpath('./GraphEval/');

valuesGroup1 = nan(size(graphCell{1,1}.Nodes.allMatrix,3),numOfDays);
for dIdx=1:numOfDays
    numOfAnimals=size(graphCell{1,dIdx}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        switch lower(strParameter)
            case 'degree'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allDegree(b,animal);
            case 'strength'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allStrength(b,animal);
            case 'eigenvector'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allEigenvector(b,animal);
            case 'betweenness' 
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allBetweenness(b,animal);
            case 'clustercoefficient' 
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allClustercoef(b,animal);
            case 'efficiency' 
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.allEfficiency(b,animal);
            case 'fa0'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.FA0(b,animal);
            case 'ad'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.AD(b,animal);
            case 'md'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.MD(b,animal);
            case 'rd'
                valuesGroup1(animal,dIdx) = graphCell{1,dIdx}.Nodes.RD(b,animal);  
            otherwise
                error('No valid Argument')
        end
    end
end

valuesGroup1(valuesGroup1==0)=nan;
tableGroup1 = array2table(valuesGroup1);
for day = 1:numOfDays
    tableGroup1.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat(strParameter," of ",strNodeName," for all subjects in group ",inputDTI.groups(1),':'));
disp(tableGroup1);

valuesGroup2 = nan(size(graphCell{2,1}.Nodes.allMatrix,3),numOfDays);
for dIdx=1:numOfDays
    numOfAnimals=size(graphCell{2,dIdx}.Nodes.allMatrix,3);
   
    for animal = 1:numOfAnimals
         switch lower(strParameter)
            case 'degree'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allDegree(b,animal);
            case 'strength'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allStrength(b,animal); 
            case 'eigenvector'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allEigenvector(b,animal);
            case 'betweenness' 
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allBetweenness(b,animal);
            case 'clustercoefficient' 
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allClustercoef(b,animal);
            case 'efficiency' 
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.allEfficiency(b,animal);
            case 'fa0'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.FA0(b,animal);
            case 'ad'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.AD(b,animal);
            case 'md'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.MD(b,animal);
            case 'rd'
                valuesGroup2(animal,dIdx) = graphCell{2,dIdx}.Nodes.RD(b,animal);  
            otherwise
                error('No valid Argument')
         end
    end
end
valuesGroup2(valuesGroup2==0)=nan;
tableGroup2 = array2table(valuesGroup2);
for day = 1:numOfDays
    tableGroup2.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat(strParameter," of ",strNodeName," for all subjects in group ",inputDTI.groups(2),':'));
disp(tableGroup2);

valuesGroup = {valuesGroup1, valuesGroup2};
plotFigure('plotLocalParameter', days, groups, valuesGroup);
title([strNodeName '-' strParameter])
ylabel(strParameter)