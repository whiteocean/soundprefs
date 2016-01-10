function varargout = soundprefs_gui(varargin)
%% soundprefs_gui.m
% Drain dripping vs rain. Why are isolated sounds coming from a
% single source more annoying? Are there just some sounds that people
% dislike? Does this overlap with miso sounds? Is it a spectrum? Gender diffs?
% What are the underlying traits of sounds that people seem to dislike? Are
% there some sounds that are pleasurable?

% Design: Play two sounds at a subject, force them to choose which one they
% would rather listen to for X amount of time. Randomly pair the sounds. 

%%

    clc
    disp('soundprefs_gui.m')
    close all;

if nargin == 0
    clear
    thisFolder=fileparts(which('soundprefs_main.m'));
    cd(thisFolder); % addpath(thisFolder);
end


%% GET MEDIA FILES

if ~exist('mediaFilePaths','var')

    % mediaFilePaths = soundprefs_getfiles();

    mediaPath = '/Users/bradleymonk/Documents/MATLAB/GIT/soundprefs/media/sounds/';
    mediaFilePaths = soundprefs_getfiles(mediaPath);
end

%% DECLARE GLOBALS

global TotalTrials
TotalTrials = 2;

global audioPlayerObj_A
global audioPlayerObj_B

global randOrd
global mediaFileA
global mediaFileB




%% CREATE RANDOM MEDIA FILE PAIRINGS

numFiles = numel(mediaFilePaths);

if nargin == 1
    randAB = varargin{1};
end


if ~exist('CurrentTrialNumber','var')

    global CurrentTrialNumber
    CurrentTrialNumber = 1;

    randOrd = reshape(randsample(numFiles,numFiles),[],2);

    randAB = randOrd(CurrentTrialNumber,:);

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



    global soundData
    soundData = {};
    assignin('base','soundData',soundData)

    soundDatas = cell(TotalTrials,7,1);

    save('soundDataAll.mat','soundDatas','-v7.3')
    whos('-file','soundDataAll.mat')
    load 'soundDataAll.mat'

    global soundMatFile
    soundMatFile = matfile('soundDataAll.mat','Writable',true);

end


%% GET SOUND FILE PAIR

mediaFileA = mediaFilePaths(randAB(1));

mediaFileB = mediaFilePaths(randAB(2));



%% PREP MEDIA FILES FOR PLAYBACK


% PREP MEDIA FILE A
[ReadAudio_A,FpS_A] = audioread(mediaFileA{1},'native');
audioPlayerObj_A = audioplayer(ReadAudio_A,FpS_A);
% audioPlayerObjFpS_A = audioPlayerObj_A.SampleRate;


% PREP MEDIA FILE A
[ReadAudio_B,FpS_B] = audioread(mediaFileB{1},'native');
audioPlayerObj_B = audioplayer(ReadAudio_B,FpS_A);
% audioPlayerObjFpS_B = audioPlayerObj_B.SampleRate;



%% DECLARE MORE GLOBALS


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


% if nargin == 2
% audioPlayerObj_A = varargin{1};
% audioPlayerObj_B = varargin{2};
% end




%% INITIALIZATION CODE FOR GUI CREATION

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


% slidetimerh = uicontrol('Parent', intimagewh, 'Units', 'normalized','Position', [.05 .05 .8 0.1],...
%                         'Style', 'slider','Min',1,'Max',30,'Value',2,'Callback', @slidetimer);




%% CALLBACK FUNCTIONS AND HELPER FUNCTIONS


function playback(playbackh, eventdata)


    set(initmenuh, 'Visible', 'Off');


    disp('Playing Sound A for 5 seconds')
    playblocking(audioPlayerObj_A,[1,audioPlayerObj_A.SampleRate*5])

    disp('Playing Sound B for 5 seconds')
    playblocking(audioPlayerObj_B,[1,audioPlayerObj_B.SampleRate*5])


    set(intimagewh, 'Visible', 'On');    



    disp('User can now select sound A or B (Sound A is currently playing)!')
    set(playAh, 'Visible', 'Off'); set(playBh, 'Visible', 'On');

    play(audioPlayerObj_B); 
    pause(audioPlayerObj_B)
    play(audioPlayerObj_A)


    tic;
    elapsedTime = toc;
    elapsedTimeAlpha = elapsedTime;

    if elapsedTime > 30
        soundprefs_endTrial(audioPlayerObj_A, audioPlayerObj_B, playTimeA, playTimeB)
    end
    
end



function playA(playAh, eventData)

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

    checkTime('A')

end




function playB(playBh, eventData)

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

    checkTime('B')

end




function checkTime(AB)

    
    while toc < 30
        % slidetimer(slidetimerh)
        pause(.1)
    end



    if toc > 30 && alldone == 0
        
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
        soundprefs_end(playTimeA, playTimeB)
        % soundprefs_endTrial(audioPlayerObj_A, audioPlayerObj_B, playTimeA, playTimeB)
        % soundprefs_nextSound(audioPlayerObj_A, audioPlayerObj_B, playTimeA, playTimeB)

        alldone = 1;
    end

end




function soundprefs_end(playTimeA, playTimeB)

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

    saveData(playTimeA, playTimeB, CurrentTrialNumber, mediaFileA, mediaFileB)
    nextSound()

end



function nextSound()


    if CurrentTrialNumber == TotalTrials
        set(initmenuh, 'Visible', 'Off');
        set(intimagewh, 'Visible', 'Off');
        disp('EXPERIMENT FINISHED!!!')
        return
    end

    CurrentTrialNumber = CurrentTrialNumber + 1;

    soundprefs_gui(randOrd(CurrentTrialNumber,:))

end



function saveData(playTimeA, playTimeB, CurrentTrialNumber, mediaFileA, mediaFileB)

    A_times{CurrentTrialNumber} = playTimeA;

    A_sumtimes{CurrentTrialNumber} = sum(playTimeA);

    B_times{CurrentTrialNumber} = playTimeB;

    B_sumtimes{CurrentTrialNumber} = sum(playTimeB);

    TrialTimes{CurrentTrialNumber} = sum(playTimeA) + sum(playTimeB);

    A_soundfiles{CurrentTrialNumber} = mediaFileA;

    B_soundfiles{CurrentTrialNumber} = mediaFileB;


    soundData = {A_times, B_times, A_sumtimes, B_sumtimes, TrialTimes, A_soundfiles, B_soundfiles};


    soundMatFile.soundDatas(CurrentTrialNumber,1:7) = soundData;
    % save('soundDataAll.mat','soundData','-append')
    % whos('-file','soundDataAll.mat')

    pause(1)
    disp('TRIAL DATA SAVED')
    pause(1)

    if CurrentTrialNumber == 2
    keyboard
    end

end




%{
function playA(playAh, eventData)

    set(playAh, 'Visible', 'Off');
    set(playBh, 'Visible', 'On');

    elapsedTimeBeta = toc;
    eTime = elapsedTimeBeta - elapsedTimeAlpha;

    playTimeB(end+1) = eTime;
    elapsedTimeAlpha = toc;

    disp('playTimeB:'); 
    disp(playTimeB); 
    disp(' ')
    disp('Sound A is now playing')


    if isplaying(audioPlayerObj_B)
        pause(audioPlayerObj_B)
    end

    resume(audioPlayerObj_A)


    if toc > 30
        soundprefs_endTrial(audioPlayerObj_A, audioPlayerObj_B, playTimeA, playTimeB)
    else
        checkTime('A')
    end


end






function playB(playBh, eventData)

    set(playBh, 'Visible', 'Off');
    set(playAh, 'Visible', 'On');

    elapsedTimeBeta = toc;
    eTime = elapsedTimeBeta - elapsedTimeAlpha;

    playTimeA(end+1) = eTime;
    elapsedTimeAlpha = toc;

    disp('playTimeA:'); 
    disp(playTimeA); 
    disp(' ')
    disp('Sound B is now playing')


    if isplaying(audioPlayerObj_A)
        pause(audioPlayerObj_A)
    end

    resume(audioPlayerObj_B)


    if toc > 30
        soundprefs_endTrial(audioPlayerObj_A, audioPlayerObj_B, playTimeA, playTimeB)
    else
        checkTime('B')
    end

end
%}


 


% IF WE WANT TO DISPLAY A TIMER ON THE GUI
% ---------------------------------------
%{
function slidetimer(slidetimerh)

%     sliderPos = get(slidetimerh,'Value');    % returns position of slider
% 
%     sliderMin = get(slidetimerh,'Min');
%     sliderMax = get(slidetimerh,'Max');
% 
%     % to determine...
%     slider_value = get(slidetimerh,'Value');
%     display(slider_value);

    tocVal = toc;
    if tocVal < 30
    slidetimerh.Value = toc;
    else
    slidetimerh.Value = 30;
    end

end
%}
% ---------------------------------------


% IF WE WANT A SINGLE BUTTON THAT SWITCHES, USE THIS CODE...
% ---------------------------------------
%{
function switchPlay(playAh, eventData)


    if isplaying(audioPlayerObj_A)
        pause(audioPlayerObj_A)
        play(audioPlayerObj_B)
    end

    if isplaying(audioPlayerObj_B)
        pause(audioPlayerObj_B)
        play(audioPlayerObj_A)
    end

end
%}
% ---------------------------------------


% IF WE WANT TO ALLOW KEYBOARD INSTEAD OF MOUSE SWITCHING...
% ---------------------------------------
%{
function keypress(lifetimeimagewh, eventData)
    key = get(lifetimeimagewh, 'CurrentKey');
    
%     currentboxID = str2double(get(boxidh, 'String'));
%     selection = get(denspineh, 'Value');
%     speed = get(movespeedh, 'Value');
%     switch speed
%         case 1
%             speed = 1;
%         case 2 
%             speed = 5;
%         case 3
%             speed = 1;
%         case 4
%             speed = 5;
%     end
%     
%     if(saveROI(currentboxID,1) ~= 0)
%     
%         if(strcmp(key, 'uparrow')==1)
%             if(selection == 1 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 11) = saveROI(currentboxID, 11)+speed;
%                 saveROI(currentboxID, 13) = saveROI(currentboxID, 13)+speed;
%                 saveROI(currentboxID, 15) = saveROI(currentboxID, 15)+speed;
%                 saveROI(currentboxID, 17) = saveROI(currentboxID, 17)+speed;
%             elseif(selection == 2 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 3) = saveROI(currentboxID, 3)+speed;
%                 saveROI(currentboxID, 5) = saveROI(currentboxID, 5)+speed;
%                 saveROI(currentboxID, 7) = saveROI(currentboxID, 7)+speed;
%                 saveROI(currentboxID, 9) = saveROI(currentboxID, 9)+speed;
%                 elseif(selection == 1 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 11) = saveROI(i, 11)+speed;
%                         saveROI(i, 13) = saveROI(i, 13)+speed;
%                         saveROI(i, 15) = saveROI(i, 15)+speed;
%                         saveROI(i, 17) = saveROI(i, 17)+speed;
%                     end
%                 end
%             elseif(selection == 2 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 3) = saveROI(i, 3)+speed;
%                         saveROI(i, 5) = saveROI(i, 5)+speed;
%                         saveROI(i, 7) = saveROI(i, 7)+speed;
%                         saveROI(i, 9) = saveROI(i, 9)+speed;
%                     end
%                 end
%             end
%         
%         elseif(strcmp(key,'downarrow')==1)
%             if(selection == 1 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 11) = saveROI(currentboxID, 11)-speed;
%                 saveROI(currentboxID, 13) = saveROI(currentboxID, 13)-speed;
%                 saveROI(currentboxID, 15) = saveROI(currentboxID, 15)-speed;
%                 saveROI(currentboxID, 17) = saveROI(currentboxID, 17)-speed;
%             elseif(selection == 2 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 3) = saveROI(currentboxID, 3)-speed;
%                 saveROI(currentboxID, 5) = saveROI(currentboxID, 5)-speed;
%                 saveROI(currentboxID, 7) = saveROI(currentboxID, 7)-speed;
%                 saveROI(currentboxID, 9) = saveROI(currentboxID, 9)-speed;
%             elseif(selection == 1 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 11) = saveROI(i, 11)-speed;
%                         saveROI(i, 13) = saveROI(i, 13)-speed;
%                         saveROI(i, 15) = saveROI(i, 15)-speed;
%                         saveROI(i, 17) = saveROI(i, 17)-speed;
%                     end
%                 end
%             elseif(selection == 2 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 3) = saveROI(i, 3)-speed;
%                         saveROI(i, 5) = saveROI(i, 5)-speed;
%                         saveROI(i, 7) = saveROI(i, 7)-speed;
%                         saveROI(i, 9) = saveROI(i, 9)-speed;
%                     end
%                 end
%             end
%             
%         elseif(strcmp(key,'leftarrow') == 1)
%             if(selection == 1 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 10) = saveROI(currentboxID, 10)-speed;
%                 saveROI(currentboxID, 12) = saveROI(currentboxID, 12)-speed;
%                 saveROI(currentboxID, 14) = saveROI(currentboxID, 14)-speed;
%                 saveROI(currentboxID, 16) = saveROI(currentboxID, 16)-speed;
%             elseif(selection == 2 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 2) = saveROI(currentboxID, 2)-speed;
%                 saveROI(currentboxID, 4) = saveROI(currentboxID, 4)-speed;
%                 saveROI(currentboxID, 6) = saveROI(currentboxID, 6)-speed;
%                 saveROI(currentboxID, 8) = saveROI(currentboxID, 8)-speed;
%             elseif(selection == 1 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 10) = saveROI(i, 10)-speed;
%                         saveROI(i, 12) = saveROI(i, 12)-speed;
%                         saveROI(i, 14) = saveROI(i, 14)-speed;
%                         saveROI(i, 16) = saveROI(i, 16)-speed;
%                     end
%                 end
%             elseif(selection == 2 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 2) = saveROI(i, 2)-speed;
%                         saveROI(i, 4) = saveROI(i, 4)-speed;
%                         saveROI(i, 6) = saveROI(i, 6)-speed;
%                         saveROI(i, 8) = saveROI(i, 8)-speed;
%                     end
%                 end
%             end
%         elseif(strcmp(key,'rightarrow') == 1)
%             if(selection == 1 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 10) = saveROI(currentboxID, 10)+speed;
%                 saveROI(currentboxID, 12) = saveROI(currentboxID, 12)+speed;
%                 saveROI(currentboxID, 14) = saveROI(currentboxID, 14)+speed;
%                 saveROI(currentboxID, 16) = saveROI(currentboxID, 16)+speed;
%             elseif(selection == 2 && get(movespeedh, 'Value') < 3)
%                 saveROI(currentboxID, 2) = saveROI(currentboxID, 2)+speed;
%                 saveROI(currentboxID, 4) = saveROI(currentboxID, 4)+speed;
%                 saveROI(currentboxID, 6) = saveROI(currentboxID, 6)+speed;
%                 saveROI(currentboxID, 8) = saveROI(currentboxID, 8)+speed;
%             elseif(selection == 1 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 10) = saveROI(i, 10)+speed;
%                         saveROI(i, 12) = saveROI(i, 12)+speed;
%                         saveROI(i, 14) = saveROI(i, 14)+speed;
%                         saveROI(i, 16) = saveROI(i, 16)+speed;
%                     end
%                 end
%             elseif(selection == 2 && get(movespeedh, 'Value') >=3)
%                 for i=1:200
%                     if(saveROI(i,1) ~= 0)
%                         saveROI(i, 2) = saveROI(i, 2)+speed;
%                         saveROI(i, 4) = saveROI(i, 4)+speed;
%                         saveROI(i, 6) = saveROI(i, 6)+speed;
%                         saveROI(i, 8) = saveROI(i, 8)+speed;
%                     end
%                 end
%             end
%         end
%       
%         drawROIs();
%     
%     else
%         errordlg('Spine / Dendrite pair does not exist!');    
%     end
            
end
%}
% ---------------------------------------

end