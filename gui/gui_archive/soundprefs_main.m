%% Sound Preferences Experiment
%% soundprefs_main.m

%Drain dripping vs rain. Why are isolated sounds coming from a
%single source more annoying? Are there just some sounds that people
%dislike? Does this overlap with miso sounds? Is it a spectrum? Gender diffs?
%What are the underlying traits of sounds that people seem to dislike? Are
%there some sounds that are pleasurable?

%Design: Play two sounds at a subject, force them to choose which one they
%would rather listen to for X amount of time. Randomly pair the sounds. 

%% CLEAR WORKSPACE | CLEAR COMMAND WINDOW | CLOSE FIGURES

clc; close all; clear

% thisFolder=fileparts(which('soundprefs_main.m'));
% cd(thisFolder); % addpath(thisFolder);




for nn = 1:3


soundprefs_gui

% uiwait



end






%% DECLARE GLOBALS

global TotalTrials
TotalTrials = 2;

global CurrentTrialNumber
CurrentTrialNumber = 1;

global audioPlayerObj_A
global audioPlayerObj_B

global randOrd
global mediaFileA
global mediaFileB



%% GET MEDIA FILES

% Get the full paths to all mp3 or mp4 files in chosen directory

% mediaFilePaths = soundprefs_getfiles();
mediaPath = '/Users/bradleymonk/Documents/MATLAB/GIT/soundprefs/media/sounds/';
mediaFilePaths = soundprefs_getfiles(mediaPath);


%% CREATE RANDOM MEDIA FILE PAIRINGS

numFiles = numel(mediaFilePaths);

randOrd = reshape(randsample(numFiles,numFiles),[],2);



%% GET SOUND FILE PAIR

mediaFileA = mediaFilePaths(randOrd(1));

mediaFileB = mediaFilePaths(randOrd(2));



%% PREP MEDIA FILES FOR PLAYBACK


% PREP MEDIA FILE A
[ReadAudio_A,FpS_A] = audioread(mediaFileA{1},'native');
audioPlayerObj_A = audioplayer(ReadAudio_A,FpS_A);
audioPlayerObjFpS_A = audioPlayerObj_A.SampleRate;


% PREP MEDIA FILE A
[ReadAudio_B,FpS_B] = audioread(mediaFileB{1},'native');
audioPlayerObj_B = audioplayer(ReadAudio_B,FpS_A);
audioPlayerObjFpS_B = audioPlayerObj_B.SampleRate;



%% OPEN SOUND SELECTOR GUI, BEGIN FULL 30-SEC PLAYBACK ALLOWING USER CHOICE


for nn = 1:TotalTrials

%     if CurrentTrialNumber == TotalTrials
%         set(initmenuh, 'Visible', 'Off');
%         set(intimagewh, 'Visible', 'Off');
%         disp('EXPERIMENT FINISHED!!!')
%         return
%     end


    soundprefs_guid(audioPlayerObj_A,audioPlayerObj_B,randOrd,...
                               TotalTrials,CurrentTrialNumber);

    CurrentTrialNumber = CurrentTrialNumber + 1;
    disp(CurrentTrialNumber)


end




%% AUDIO CONTROLS

% play(audioPlayerObj_A)
% 
% 
% % playblocking(audioObj)
% % sound(ReadAudio,FpS);
% 
% isplaying(audioPlayerObj_A)
% pause(audioPlayerObj_A)
% resume(audioPlayerObj_A)
% stop(audioPlayerObj_A)



%%