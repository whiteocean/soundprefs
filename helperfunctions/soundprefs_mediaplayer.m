function [] = soundprefs_mediaplayer()

%% SETUP AUDIO VIDEO PLAYBACK

implay('chip.avi');


path_vid = '/Users/bradleymonk/Documents/MATLAB/GIT/misophonia/media/chip.mp4';

PlayVideoFile(path_vid)

[video, audio] = mmread(path_vid);
play(audio)

system('osascript vlc.scpt')
system('osascript vlcstatus.scpt')


fig1=figure;
vlc=actxcontrol('VideoLAN.VLCPlugin.2',[50 50 700 500],fig1);
disp(vlc.versionInfo());
vlc.BaseURL = 'file//e:/Yellelama.mp3';  %%%%write ur file location over here
vlc.playlist.add('e:/Yellelama.mp3');     %%%%write ur file location over here
vlc.playlist.items.get;
vlc.playlist.play();






videoFReader = vision.VideoFileReader('chip.avi');
videoPlayer = vision.VideoPlayer;

[soundwav,fps] = audioread('chip.mp4');
player = audioplayer(soundwav,fps);


pause(2)
play(player,fps)

while ~isDone(videoFReader)
  [videoFrame] = step(videoFReader);
  step(videoPlayer, videoFrame);
end
release(videoPlayer);
release(videoFReader);

end