function [] = runVLC()
%% runVLC.m

path_vlc = '/Applications/VLC.app/Contents/MacOS/VLC';

% update this to be whatever path your file is in
% path_vid = '/Users/Miren/Documents/MATLAB/Misophonia/chips_aud_vid_short.mp4'; 
path_vid = '/Users/bradleymonk/Documents/MATLAB/GIT/soundprefs/Media/chips_aud_vid_short.mp4';

syscmd_appVLC = 'osascript vlc.scpt';
syscmd_runVLC = ['open -a ' path_vlc ' ' path_vid];
syscmd_quitVLC = 'osascript -e ''quit app "VLC"''';
syscmd_killTERM = 'killall -TERM Terminal';


disp('initiate: opening VLC player app')
system(syscmd_appVLC,'-echo')
disp('finished: opening VLC player app')

pause(2)

disp('initiate: playing media in VLC player')
system(syscmd_runVLC,'-echo')
disp('finished: playing media in VLC player')

pause(16)

disp('initiate: closing VLC player app')
system(syscmd_quitVLC,'-echo')
% system('osascript vlcstatus.scpt')
disp('finished: closing VLC player app')

pause(2)

disp('initiate: closing Terminal')
system(syscmd_killTERM,'-echo')
disp('finished: closing Terminal')


end