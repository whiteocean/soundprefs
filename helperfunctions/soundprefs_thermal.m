function [] = soundprefs_thermal()
%% soundprefs_thermal


%%

% Delete any active connection with the device
imaqreset



%% Experiment parameters
%{
SampleRate = 10000;
TimeValue = 4;
TimeValueShock = TimeValue - 0.5;
Samples = 0:(1/SampleRate):TimeValue;
freqS1 = 600;
freqS2 = 350;
toneS1 = sin(2*pi*freqS1*Samples);
toneS2 = sin(2*pi*freqS2*Samples);
ITI = 10;


play(eval(noteList(randOrd(nn)).objs));

audioread()
audioplayer()
playblocking(toneOBJ)
%}



%% ACQUIRE IMAGE ACQUISITION DEVICE (THERMAL CAMERA) OBJECT

% webcamlist
% cam = webcam('FaceTime')

% preview(cam)
% img = snapshot(cam);
% closePreview(cam)
% imshow(img)
% clear('cam');


cam = webcam; pause(1);

% cam.Brightness = 150;
camres = cam.AvailableResolutions;
camres = camres{1};
sx = strfind(camres, 'x');
camresX = str2num(camres(1:sx-1));
camresY = str2num(camres(sx+1:end));



Nframes = 10;
imgs = {zeros(camresY,camresX)};
imgs = repmat(imgs,Nframes,1);

for nn = 1:Nframes
    imgs{nn} = snapshot(cam);    % Acquire a single image.
end
clear('cam');

figure(1)
for nn = 1:Nframes
    imshow(imgs{nn})
    drawnow
end




%% SETUP THERMAL IMAGING CAMERA
%{.
% imaqtool
% imaqhwinfo
% vidObj = videoinput('macvideo', 1, 'YCbCr422_1280x720'); % CHANGE THIS TO THERMAL DEVICE ID


% imaqfind
% utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', 'helper');
% addpath(utilpath);
% vidObj = videoinput('macvideo', 1, 'YCbCr422_1280x720');
vidObj = videoinput('winvideo', 1, 'UYVY_720x480'); % default
src = getselectedsource(vidObj);

% src.AnalogVideoFormat = 'ntsc_m_j';

% vidObj.FramesPerTrigger = 1;
% preview(vidObj);
% start(vidObj);
% pause(5)
% stop(vidObj);
% stoppreview(vidObj);
% delete(vidObj);
% clear vid src
% vidsrc = getselectedsource(vidObj);
% diskLogger = VideoWriter([thisFolder '/thermalVid1.avi'],'Uncompressed AVI');
vidObj.LoggingMode = 'memory';
% vidObj.DiskLogger = file;
% vidObj.ROIPosition = [488 95 397 507];
vidObj.ReturnedColorspace = 'rgb';
% vidObjSource = vidObj.Source;
% preview(vidObj);    pause(3);   stoppreview(vidObj);
% TriggerRepeat is zero-based
vidObj.TriggerRepeat = total_trials * 6 + 6;
vidObj.FramesPerTrigger = 1;
triggerconfig(vidObj, 'manual');

start(vidObj);
% stop(vidObj);
% stoppreview(vidObj);
% delete(vidObj);
% clear vidObj

% Once a key is pressed, the experiment will begin
% main_keyboard_index = input_device_by_prompt('Please press any key on the main keyboard\n', 'keyboard');
disp('Starting experiment now...');


Frames{1} = uint8(zeros(480,720,3));
for nn = 1:length(trial_data)*8
    Frames{nn} = uint8(zeros(480,720,3));
end

Frames = {};            % create thermal vid frame container
FramesTS = {};          % create thermal vid timestamp container
startTime = GetSecs;
ff=1;
%}



%% START MAIN LOOP

for trial = 1:length(trial_data)
    
    % Allows time to get movie setup
    if trial == 1
      pause(10);
    end
    
    % Get the exact timing of the tone start
    trial_data.tone_start(trial,1) = GetSecs;
    fprintf('Tone %d beginning...\n', trial);
    trial_data.tone_start_real(trial,1) = trial_data.tone_start(trial,1) - startTime;
    
    % Present the sound
    if trial_data.stim(trial,1) == 1
        sound(toneS1, SampleRate);
        % GET THERMAL CAM SNAPSHOT
        pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        
        while GetSecs < trial_data.tone_start(trial,1) + TimeValue  
        end
        if strcmp(trial_data.phase(trial,1),'Acquisition') && shock == 1 && trial_data.shock(trial,1) == 1
            send_to_daq('solenoid_1',.015);
        end
    else
        sound(toneS2, SampleRate);
        % GET THERMAL CAM SNAPSHOT
       pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        pause(1)
        trigger(vidObj);
        [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
        Frames{ff} = frame; ff=ff+1;
        FramesTS{end+1} = ts;
        while GetSecs < trial_data.tone_start(trial,1) + TimeValue
        end
    end

    % Get the exact timing of the tone end
    trial_data.tone_end(trial,1) = GetSecs;
    trial_data.tone_end_real(trial,1) = trial_data.tone_end(trial,1) - startTime;

    % Get the exact duration of the tone period
    trial_data.tone_time(trial,1) = trial_data.tone_end(trial,1) - trial_data.tone_start(trial,1);
    
    % Get exact timing of the ITI start
    trial_data.ITI_start(trial,1) = GetSecs;
    trial_data.ITI_start_real(trial,1) = trial_data.ITI_start(trial,1) - startTime;    
    
    trigger(vidObj);
    [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
    Frames{ff} = frame; ff=ff+1;
    FramesTS{end+1} = ts;
    
    pause(ITI/4);
    
    trigger(vidObj);
    [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
    Frames{ff} = frame; ff=ff+1;
    FramesTS{end+1} = ts;
    
    pause(ITI/4);

    trigger(vidObj);
    [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
    Frames{ff} = frame; ff=ff+1;
    FramesTS{end+1} = ts;

    pause(ITI/4);
    
    trigger(vidObj);
    [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
    Frames{ff} = frame; ff=ff+1;
    FramesTS{end+1} = ts;
    
    pause(ITI/4);

    trigger(vidObj);
    [frame, ts] = getdata(vidObj, vidObj.FramesPerTrigger);
    Frames{ff} = frame; ff=ff+1;
    FramesTS{end+1} = ts;    
        
    % Get exact timing of the ITI end 
    trial_data.ITI_end(trial,1) = GetSecs;
    trial_data.ITI_end_real(trial,1) = trial_data.ITI_end(trial,1) - startTime;

    % Get the exact duration of the ITI period
    trial_data.ITI_time(trial,1) = trial_data.ITI_end(trial,1) - trial_data.ITI_start(trial,1);

    %% Save data
    if mod(trial,10)==0
        outfile=sprintf('FC_Day1_s%s_%s.mat', subject_id, date);
        save([sub_dir, '/' outfile],'trial_data', 'Frames', 'FramesTS', 'FrameOrd');
    end
end

stop(vidObj); wait(vidObj);

%% PLAYBACK THERMAL VIDEO FRAMES & SAVE DATA
close all
for nn = 1:numel(Frames)
    figure(1)
    imagesc(Frames{nn})
    axis image
    drawnow
    pause(.1)
end



end
