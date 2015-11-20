function [mediaFilePaths] = soundprefs_getfiles()
%% soundprefs_getfiles.m


%% GET ALL MP3 or MP4 FILES IN UIGET SPECIFIED DIRECTORY

% persistent LookInFolder 

thisfile='soundprefs_getfiles';
LookInFolder = uigetdir(thisfile);

mp4dir = dir(fullfile(LookInFolder,'/*.mp*'));
mediaFiles = {mp4dir.name};

[fppath,fpdir,fpext] = fileparts(LookInFolder);
mediaFolderPath = [fppath,'/',fpdir,'/']

for nn = 1:numel(mediaFiles)
    mediaFilePaths{nn} = [mediaFolderPath mediaFiles{nn}];
end

% The variable 'mediaFilePaths' now contains the full paths to all mp3 or mp4 files in selected dir


end