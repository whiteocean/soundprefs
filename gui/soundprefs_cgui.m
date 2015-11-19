function varargout = soundprefs_cgui(varargin)
%% soundprefs_cgui


global tempfilename
tempfilename = '';

global LifeImageFile
LifeImageFile = 0;

if nargin > 0
audioPlayerObj_A = varargin{1};
audioPlayerObj_B = varargin{2};
end


%Initialization code for GUI creation


initmenuh = figure('Units', 'normalized','Position', [.4 .4 .2 .15], 'BusyAction', 'cancel', 'Menubar', 'none', 'Name', 'FLIM analysis', 'Tag', 'FLIM analysis'); 
beginplaybackh = uicontrol('Units', 'normalized','Parent', initmenuh, 'Position', [.1 .1 .8 .8], 'String', 'Begin Playback', 'FontSize', 16, 'Tag', 'Begin Playback', 'Callback', @beginplayback);


intimagewh = figure('Units', 'normalized','Position', [.4 .4 .2 .15], 'BusyAction', 'cancel', 'Menubar', 'none', 'Name', 'Lifetime image', 'Tag', 'lifetime image', 'Visible', 'Off', 'KeyPressFcn', @keypress);

playAh = uicontrol('Parent', intimagewh, 'Units', 'normalized', 'Position', [0.07 0.3 0.4 0.5], 'FontSize', 14, 'String', 'Play Sound A', 'Callback', @playA);
playBh = uicontrol('Parent', intimagewh, 'Units', 'normalized', 'Position', [0.55 0.3 0.4 0.5], 'FontSize', 14, 'String', 'Play Sound B', 'Callback', @playB);




function beginplayback(hObject, eventdata)

    set(intimagewh, 'Visible', 'On');
    set(initmenuh, 'Visible', 'Off');
    
    play(audioPlayerObj_A)
    
end




function playA(playAh, eventData)


    if isplaying(audioPlayerObj_B)
        pause(audioPlayerObj_B)
    end

    play(audioPlayerObj_A)

end



function playB(playBh, eventData)

    if isplaying(audioPlayerObj_A)
        pause(audioPlayerObj_A)
    end

    play(audioPlayerObj_B)

end




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