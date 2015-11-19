function [] = soundprefs_playsounds(mediaFilePaths,randOrd)
%% soundprefs_playsounds.m


keyboard

%% GET SOUND FILE PAIR

mediaFileA = mediaFilePaths(randOrd(1));

mediaFileB = mediaFilePaths(randOrd(2));


%%

% [ReadAudio,FpS] = audioread(mediaFileA{1});
[ReadAudio_A,FpS_A] = audioread(mediaFileA{1},'native');

audioPlayerObj_A = audioplayer(ReadAudio_A,FpS_A);
audioPlayerObjFpS_A = audioPlayerObj_A.SampleRate;


play(audioPlayerObj_A)
% playblocking(audioObj)
% sound(ReadAudio,FpS);

isplaying(audioPlayerObj_A)
pause(audioPlayerObj_A)
resume(audioPlayerObj_A)





end