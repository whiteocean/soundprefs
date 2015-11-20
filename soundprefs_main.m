%% Sound Preferences Experiment
%% soundprefs_main.m

%Drain dripping vs rain. Why are isolated sounds coming from a
%single source more annoying? Are there just some sounds that people
%dislike? Does this overlap with miso sounds? Is it a spectrum? Gender diffs?
%What are the underlying traits of sounds that people seem to dislike? Are
%there some sounds that are pleasurable?

%Design: Play two sounds at a subject, force them to choose which one they
%would rather listen to for X amount of time. Randomly pair the sounds. 

clc; close all; clear

thisFolder=fileparts(which('soundprefs_main.m'));
cd(thisFolder); % addpath(thisFolder);



global audioPlayerObj_A
global audioPlayerObj_B


%% GET MEDIA FILES

% Get the full paths to all mp3 or mp4 files in chosen directory
mediaFilePaths = soundprefs_getfiles();




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



%% PLAY 5-SECOND TEASER OF EACH CLIP


% play(playerObj,[start,stop])

% disp('Playing Sound A')
% playblocking(audioPlayerObj_A,[1,audioPlayerObjFpS_A*5])
% 
% disp('Playing Sound B')
% playblocking(audioPlayerObj_B,[1,audioPlayerObjFpS_B*5])



%% OPEN SOUND SELECTOR GUI, BEGIN FULL 30-SEC PLAYBACK ALLOWING USER CHOICE


soundprefs_cgui(audioPlayerObj_A,audioPlayerObj_B)


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