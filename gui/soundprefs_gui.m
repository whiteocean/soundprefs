function varargout = soundprefs_gui(varargin)
% SOUNDPREFS_GUI MATLAB code for soundprefs_gui.fig
%      SOUNDPREFS_GUI, by itself, creates a new SOUNDPREFS_GUI or raises the existing
%      singleton*.
%
%      H = SOUNDPREFS_GUI returns the handle to a new SOUNDPREFS_GUI or the handle to
%      the existing singleton*.
%
%      SOUNDPREFS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOUNDPREFS_GUI.M with the given input arguments.
%
%      SOUNDPREFS_GUI('Property','Value',...) creates a new SOUNDPREFS_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before soundprefs_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to soundprefs_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help soundprefs_gui

% Last Modified by GUIDE v2.5 19-Nov-2015 00:27:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @soundprefs_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @soundprefs_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before soundprefs_gui is made visible.
function soundprefs_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to soundprefs_gui (see VARARGIN)


% Choose default command line output for soundprefs_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




audioPlayerObj_A = varargin{1};
audioPlayerObjFpS_A = audioPlayerObj_A.SampleRate;
audioPlayerObj_B = varargin{2};
audioPlayerObjFpS_B = audioPlayerObj_B.SampleRate;



initialize_gui(hObject, handles, false);

% UIWAIT makes soundprefs_gui wait for user response (see UIRESUME)
% uiwait(handles.soundprefs_gui_tag);


% --- Outputs from this function are returned to the command line.
function varargout = soundprefs_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --------------------------------------------------------------------


% --- Executes on button press in SoundA.
function SoundA_Callback(hObject, eventdata, handles)


Stag = handles.SoundA.Tag;
disp(Stag)
play(audioPlayerObj_A,[1,audioPlayerObjFpS_A*5])

set(handles.SoundA, 'String', Stag);


% --- Executes on button press in SoundB.
function SoundB_Callback(hObject, eventdata, handles)

Stag = handles.SoundB.Tag;
disp(Stag)
set(handles.SoundB, 'String', Stag);



% --------------------------------------------------------------------


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'SoundB') && ~isreset
    return;
end


set(handles.SoundA, 'String', handles.SoundA.Tag);
set(handles.SoundB,  'String', handles.SoundA.Tag);


% Update handles structure
guidata(handles.soundprefs_gui_tag, handles);



