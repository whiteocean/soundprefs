function [] = soundprefs_recordaudio()

%% SETUP AUDIO RECORDING

recObj = audiorecorder;

    disp('Start speaking.')
recordblocking(recObj, 5);
    disp('End of Recording.');

play(recObj); pause(5)
    disp('End of Playback.');


audiowrite('audio1.wav',getaudiodata(recObj),recObj.SampleRate);
[soundwav,fps] = audioread('audio1.wav');
player = audioplayer(soundwav,fps);
play(player,fps)



% audioinfo     Information about audio file
% audioread     Read audio file
% audiowrite	Write audio file
% mmfileinfo	Information about multimedia file
% VideoReader	Read video files
% VideoWriter	Write video files

end