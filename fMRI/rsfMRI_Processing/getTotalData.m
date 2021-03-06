function [OutStruct]=getTotalData(inputFMRI)

%% getTotalData
% This function is used by several scripts and is not meant to be
% used manually. It merges all given fMRI-connectivity-MAT-Files.

path  = inputFMRI.out_path;
groups = inputFMRI.groups;
days = inputFMRI.days;
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;

numOfRegions = length(inputFMRI.index);
index=inputFMRI.index;

TotalData=nan*ones(numOfRegions,numOfRegions ,10,length(days),length(groups));
Cat=[];

for d = 1:length(days)
    for g = 1:length(groups)
        cur_path = char(fullfile(path,groups(g)));
        matFile_cur = ([cur_path '/' char(days(d)) '.mat']);
        load(matFile_cur, 'infoFMRI');              
        [p, q, o]=size(infoFMRI.matrix(index,index,:));        
        TotalData(1:p,1:q,1:o,d,g)=squeeze(infoFMRI.matrix(index,index,:)); 
    end
end
OutStruct.Data=TotalData;
OutStruct.Category=Cat;
OutStruct.Indices=index;
OutStruct.Acronym=acronyms(index);

end