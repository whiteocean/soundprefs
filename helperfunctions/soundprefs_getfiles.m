function [mediaFilePaths] = soundprefs_getfiles()
%% soundprefs_getfiles.m


%% GET ALL MP4 FILES IN UIGET SPECIFIED DIRECTORY

% persistent LookInFolder 

thisfile='soundprefs_getfiles';
LookInFolder = uigetdir(thisfile);

mp4dir = dir(fullfile(LookInFolder,'/*.mp4'));
mediaFiles = {mp4dir.name};

[fppath,fpdir,fpext] = fileparts(LookInFolder);
mediaFolderPath = [fppath,'/',fpdir,'/']

for nn = 1:numel(mediaFiles)
    mediaFilePaths{nn} = [mediaFolderPath mediaFiles{nn}];
end

% The variable 'mediaFilePaths' now contains the full paths to all mp4 files in selected dir


end