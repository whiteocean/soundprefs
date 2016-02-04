function soundprefs_gui
%% soundprefs_gui.m
% Drain dripping vs rain. Why are isolated sounds coming from a
% single source more annoying? Are there just some sounds that people
% dislike? Does this overlap with miso sounds? Is it a spectrum? Gender diffs?
% What are the underlying traits of sounds that people seem to dislike? Are
% there some sounds that are pleasurable?

% Design: Play two sounds at a subject, force them to choose which one they
% would rather listen to for X amount of time. Randomly pair the sounds. 

%% CLEAR COMMAND WINDOW | CLOSE FIGURES

clc; close all; clear
disp('soundprefs_gui.m')


%% DECLARE GLOBALS

global TotalTrials
TotalTrials = 2;

global CurrentTrialNumber
CurrentTrialNumber = 1;

global numPairs

global audioPlayerObj_A
global audioPlayerObj_B

global randOrd
global mediaFileA
global mediaFileB

global trialSecs
trialSecs = 15;

global alldata


%% GET MEDIA FILES

% Get the full paths to all mp3 or mp4 files in chosen directory

% mediaFilePaths = soundprefs_getfiles();
mediaPath = '/Users/bradleymonk/Documents/MATLAB/GIT/soundprefs/media/sounds';
mediaFilePaths = soundprefs_getfiles(mediaPath);


%% CREATE RANDOM MEDIA FILE PAIRINGS

numFiles = numel(mediaFilePaths);

randOrd = reshape(randsample(numFiles,numFiles),[],2);

numPairs = size(randOrd,1);


%% GET SOUND FILE PAIR

mediaFileA = mediaFilePaths(randOrd(:,1));
mediaFileB = mediaFilePaths(randOrd(:,2));


% getaudio(CurrentTrialNumber)

%% DECLARE GLOBALS

global A_times
global A_sumtimes
global B_times
global B_sumtimes
global TrialTimes
global A_soundfiles
global B_soundfiles

A_times = {};
A_sumtimes = {};
B_times = {};
B_sumtimes = {};
TrialTimes = {};
A_soundfiles = {};
B_soundfiles = {};


global playTimeA
playTimeA = 0.0;

global playTimeB
playTimeB = 0.0;

global elapsedTime
elapsedTime = 0.0;

global elapsedTimeAlpha
elapsedTimeAlpha = 0.0;

global elapsedTimeBeta
elapsedTimeBeta = 0.0;

global alldone
alldone = 0;




%% INITIALIZATION CODE FOR GUI CREATION



clc; close all;
disp('Current Trial Number...')
disp(CurrentTrialNumber)

initmenuh = figure('Units', 'normalized','Position', [.4 .4 .2 .15], 'BusyAction', 'cancel',...
                   'Menubar', 'none', 'Name', 'soundprefs_exp', 'Tag', 'soundprefs_exp'); 

playbackh = uicontrol('Units', 'normalized','Parent', initmenuh, 'Position', [.1 .1 .8 .8],...
                           'String', 'Playback', 'FontSize', 16, 'Tag', 'Playback', 'Callback', @playback);


intimagewh = figure('Units', 'normalized','Position', [.4 .4 .2 .15], 'BusyAction', 'cancel',...
                    'Menubar', 'none', 'Name', 'Initial_Image', 'Tag', 'Initial_Image',...
                    'Visible', 'Off', 'KeyPressFcn', @keypress);


playAh = uicontrol('Parent', intimagewh, 'Units', 'normalized', 'Position', [0.07 0.3 0.4 0.5],...
                    'FontSize', 14, 'String', 'Play Sound A', 'Callback', @playA);


playBh = uicontrol('Parent', intimagewh, 'Units', 'normalized', 'Position', [0.55 0.3 0.4 0.5],...
                   'FontSize', 14, 'String', 'Play Sound B', 'Callback', @playB);




%% CALLBACK FUNCTIONS AND HELPER FUNCTIONS


% PREP MEDIA FILES FOR PLAYBACK
function getaudio(CurrentTrialNumber)
    % PREP MEDIA FILE A
    [ReadAudio_A,FpS_A] = audioread(mediaFileA{CurrentTrialNumber},'native');
    audioPlayerObj_A = audioplayer(ReadAudio_A,FpS_A);
    audioPlayerObjFpS_A = audioPlayerObj_A.SampleRate;


    % PREP MEDIA FILE A
    [ReadAudio_B,FpS_B] = audioread(mediaFileB{CurrentTrialNumber},'native');
    audioPlayerObj_B = audioplayer(ReadAudio_B,FpS_A);
    audioPlayerObjFpS_B = audioPlayerObj_B.SampleRate;

end





function playback(varargin)

    alldone = 0;
    getaudio(CurrentTrialNumber)
    fprintf('Current trial: %s \r', num2str(CurrentTrialNumber))


    set(initmenuh, 'Visible', 'Off');


    disp('Playing Sound A for 5 seconds')
    playblocking(audioPlayerObj_A,[1,audioPlayerObj_A.SampleRate*5])

    disp('Playing Sound B for 5 seconds')
    playblocking(audioPlayerObj_B,[1,audioPlayerObj_B.SampleRate*5])


    set(intimagewh, 'Visible', 'On');    



    disp('User can now select sound A or B (Sound B is currently playing)!')
    set(playAh, 'Visible', 'Off'); set(playBh, 'Visible', 'On');

    play(audioPlayerObj_B); 
    pause(audioPlayerObj_B)
    play(audioPlayerObj_A)
    pause(audioPlayerObj_A)

    tic;
    elapsedTimeAlpha = toc;
    playB(playBh)
    
end



function playA(playAh, varargin)

    set(playAh, 'Visible', 'Off');
    set(playBh, 'Visible', 'On');


    playTimeB(end+1) = toc - elapsedTimeAlpha;
    elapsedTimeAlpha = toc;


    disp('playTimeB:'); disp(playTimeB); disp(' ')
    disp('Sound A is now playing')


    if isplaying(audioPlayerObj_B)
        pause(audioPlayerObj_B)
    end

    resume(audioPlayerObj_A)

    % checkTime('A')
    while toc < trialSecs
        pause(.1)
    end
    if toc > trialSecs
        checkTime('A')
    end

end




function playB(playBh, varargin)

    set(playBh, 'Visible', 'Off');
    set(playAh, 'Visible', 'On');

    playTimeA(end+1) = toc - elapsedTimeAlpha;
    elapsedTimeAlpha = toc;

    disp('playTimeA:'); disp(playTimeA); disp(' ')
    disp('Sound B is now playing')


    if isplaying(audioPlayerObj_A)
        pause(audioPlayerObj_A)
    end

    resume(audioPlayerObj_B)

    % checkTime('B')
    while toc < trialSecs
        pause(.1)
    end
    if toc > trialSecs
        checkTime('B')
    end

end




function checkTime(AB)


    if toc > trialSecs && alldone == 0
    
        if strcmp('A',AB)
            playTimeA(end+1) = toc - elapsedTimeAlpha;
        elseif strcmp('B',AB)
            playTimeB(end+1) = toc - elapsedTimeAlpha;
        end


        if isplaying(audioPlayerObj_A)
            disp('stopping audio playback')
            stop(audioPlayerObj_A)
        end

        if isplaying(audioPlayerObj_B)
            disp('stopping audio playback')
            stop(audioPlayerObj_B)
        end

        set(initmenuh, 'Visible', 'On');
        set(intimagewh, 'Visible', 'Off');

        saveData(playTimeA, playTimeB, CurrentTrialNumber)
        
        alldone = 1; pause(1)
    end


    if alldone == 1
        playTimeA = [];
        playTimeB = [];
        A_times = [];
        B_times = [];
        
        CurrentTrialNumber = CurrentTrialNumber+1;
        alldone = 2;
    end


end




function saveData(playTimeA, playTimeB, CurrentTrialNumber)


    disp(' '); disp(' '); disp(' '); disp(' ')
    disp('Trial finished'); disp(' ')

    disp('Elapsed time segments for Sound A')
    disp(playTimeA);

    fprintf('\r Total seconds Sound A was played: % 9.6g  \r \r',sum(playTimeA))

    disp('Elapsed time segments for Sound B')
    disp(playTimeB);

    fprintf('\r Total seconds Sound B was played: % 9.6g  \r',sum(playTimeB))


    totElapsedTime = sum(playTimeA) + sum(playTimeB);
    fprintf('\r Total elapsed seconds: % 9.6g  \r',totElapsedTime)

    disp(' '); disp(' ');


    A_times{CurrentTrialNumber} = playTimeA;

    A_sumtimes{CurrentTrialNumber} = sum(playTimeA);

    B_times{CurrentTrialNumber} = playTimeB;

    B_sumtimes{CurrentTrialNumber} = sum(playTimeB);

    TrialTimes{CurrentTrialNumber} = sum(playTimeA) + sum(playTimeB);


    alldata{CurrentTrialNumber} = {playTimeA, playTimeB; mediaFileA{CurrentTrialNumber}, mediaFileB{CurrentTrialNumber}};


    if CurrentTrialNumber == 2
        save('test.mat','alldata')
    end

    
end




end