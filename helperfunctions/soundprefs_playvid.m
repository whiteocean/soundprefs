function soundprefs_playvid(filepath)


    handles.filepath = filepath;
    % Create figure to receive activex
    handles.hFigure = figure('position', [50 50 960 560], 'menubar', 'none', 'numbertitle','off','name', ['Video: ' filepath], 'tag', 'VideoPlay', 'resize', 'off');
    % Create play/pause and seek to 0 button
    handles.hTogglePlayButton = uicontrol(handles.hFigure, 'position', [0 540 80 21], 'string', 'play/pause', 'callback', @TogglePlayPause);
    handles.hSeekToZeroButton = uicontrol(handles.hFigure, 'position', [81 540 80 21], 'string', 'begining', 'callback', @SeekToZero);
    % Create activex control
    handles.vlc = actxcontrol('VideoLAN.VLCPlugin.2', [0 0 960 540], handles.hFigure);
    % Format filepath so that VLC can use it (it's what was a problematic for me initialy)
    filepath(filepath=='\')='/';
    filepath = ['file://localhost/' filepath];
    % Add file to playlist
    handles.vlc.playlist.add(filepath);
    % Play file
    handles.vlc.playlist.play();
    % Deinterlace
    handles.vlc.video.deinterlace.enable('x');
    % Go back to begining of file
    handles.vlc.input.time = 0;
    % Register an event to trigger when video is being played regularly
    handles.vlc.registerevent({'MediaPlayerTimeChanged', @MediaPlayerTimeChanged});
    % Save handles 
    guidata(handles.hFigure, handles);

function MediaPlayerTimeChanged(varargin)
    % Displays running time in application title
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    set(hFigure, 'name', [handles.filepath ' ; ' num2str(handles.vlc.input.Time/1000) ' sec.']); 
    
function TogglePlayPause(varargin)
    % Toggle Play/Pause
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    handles.vlc.playlist.togglePause();

function SeekToZero(varargin)
    % Seek to begining of file
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    handles.vlc.input.Time = 0;
