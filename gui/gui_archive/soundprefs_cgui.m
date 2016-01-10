function varargout = soundprefs_cgui(varargin)
%% soundprefs_cgui.m

clc
disp('soundprefs_cgui.m')



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


if nargin > 0
audioPlayerObj_A = varargin{1};
audioPlayerObj_B = varargin{2};
end


%Initialization code for GUI creation


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