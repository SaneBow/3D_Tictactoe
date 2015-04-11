function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 11-Apr-2015 21:21:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% My own codes start from here
gameReset(3,handles);
setGameControlStatus('reset',handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in resetbtn.
function resetbtn_Callback(hObject, eventdata, handles)
% hObject    handle to resetbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.dimtext,'String','3');
gameReset(3,handles);
setGameControlStatus('reset',handles);
set(handles.mousechkbox,'Value',0);
rotate3d off;

% --- Executes on button press in mousechkbox.
function mousechkbox_Callback(hObject, eventdata, handles)
% hObject    handle to mousechkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of mousechkbox
if get(hObject,'Value')
    rotate3d on;
else
    rotate3d off;
end


% --- Executes on button press in undobtn.
function undobtn_Callback(hObject, eventdata, handles)
% hObject    handle to undobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CUBES WON;
[prev,to_undo] = undoMove;
if to_undo == [0 0 0]
    disp('Undo not available');
    return;
end
set(CUBES(to_undo(1),to_undo(2),to_undo(3)),'FaceColor',0.2*[1 1 1],'FaceAlpha',0.15);
if prev == [0 0 0]
    set(CUBES,'EdgeColor','[0 0 0]','LineWidth',0.5); %Clear highlight
else 
    highLight(CUBES(prev(1),prev(2),prev(3)));
end
setPlayerLabels(handles);
setGameControlStatus('move',handles);
if WON == 1
    WON = 0;
    hideWinner(handles);
end

% --- Executes on button press in redobtn.
function redobtn_Callback(hObject, eventdata, handles)
% hObject    handle to redobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PLAYER CUBES WON;
if PLAYER == 1
    color = [1 0 0];
elseif PLAYER == 2
    color = [0 0 1];
else
    disp('[Err] PLAYER not set');
end
to_redo = redoMove;
if to_redo == [0 0 0]
    disp('Redo not available');
    return;
end
set(CUBES(to_redo(1),to_redo(2),to_redo(3)),'FaceColor',color,'FaceAlpha',1);
highLight(CUBES(to_redo(1),to_redo(2),to_redo(3)));
% Check game status
if isWin()
    % Game over
    WON = 1;
    showWinner(handles);
else
    setPlayerLabels(handles);
end
setGameControlStatus('move',handles);


function dimtext_Callback(hObject, eventdata, handles)
% hObject    handle to dimtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimtext as text
%        str2double(get(hObject,'String')) returns contents of dimtext as a double


% --- Executes during object creation, after setting all properties.
function dimtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on dimtext and none of its controls.
function dimtext_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to dimtext (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'return')
    dim = str2double(get(handles.dimtext,'String'));
    gameReset(dim,handles);
    setGameControlStatus('reset',handles);
end

% --- Executes on button press in dimbtn.
function dimbtn_Callback(hObject, eventdata, handles)
% hObject    handle to dimbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dim = str2double(get(handles.dimtext,'String'));
gameReset(dim,handles);
setGameControlStatus('reset',handles);

% --- Executes on button press in restartbtn.
function restartbtn_Callback(hObject, eventdata, handles)
% hObject    handle to restartbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dim = str2double(get(handles.dimtext,'String'));
gameReset(dim,handles);
setGameControlStatus('reset',handles);


% --- Executes on slider movement.
function zoomslider_Callback(hObject, eventdata, handles)
% hObject    handle to zoomslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
factor = get(hObject,'Value');
zoom_Axes(factor,handles);


% --- Executes during object creation, after setting all properties.
function zoomslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoomslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in leftrotbtn.
function leftrotbtn_Callback(hObject, eventdata, handles)
% hObject    handle to leftrotbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate_Axes('left',handles);

% --- Executes on button press in rightrotbtn.
function rightrotbtn_Callback(hObject, eventdata, handles)
% hObject    handle to rightrotbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate_Axes('right',handles);

% --- Executes on button press in downrotbtn.
function downrotbtn_Callback(hObject, eventdata, handles)
% hObject    handle to downrotbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate_Axes('down',handles);

% --- Executes on button press in uprotbtn.
function uprotbtn_Callback(hObject, eventdata, handles)
% hObject    handle to uprotbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotate_Axes('up',handles);


% --- Executes on button press in helpbtn.
function helpbtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'                           About                                  ';...
        'Author:   WANG Xianbo                                             ';...
        'Email:    sanebow@gmail.com                                       ';...
        '                                                                  ';...
        '                           Help                                   ';...
        'Keyboard: Use arrows to rotate (up/down/left/right)               ';...
        'Mouse:     Click to set next move                                 ';... 
        'GUI:                                                              ';...
        '[Game Control Panel] Redo/Undo/Restart                            ';...
        '[View Control Panel] Rotation/Zoom/Mouse-rotate                   ';...
        '[Settings Panel] Change dimension                                                                  ';...
        '                                                                  ';...
        },'About/Help','help');

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'rightarrow'
        rotate_Axes('right',handles);
    case 'leftarrow'
        rotate_Axes('left',handles);
    case 'downarrow'
        rotate_Axes('down',handles);
    case 'uparrow'
        rotate_Axes('up',handles);
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hideWinner(handles);



% ==========================================================
% ------------------ Custom Callbacks ----------------------
% ==========================================================
function cube_Callback(hObject, eventdata, position, handles)
global WON;
if get(hObject,'FaceAlpha') == 1 || WON == 1
    return
end

global PLAYER;
if PLAYER == 1
    color = [1 0 0];
elseif PLAYER == 2
    color = [0 0 1];
else
    disp('[Err] PLAYER not set');
end
set(hObject,'FaceColor',color,'FaceAlpha',1);
highLight(hObject);
setMove(position);

% Check game status
if isWin()
    % Game over
    WON = 1;
    showWinner(handles);
else
    setPlayerLabels(handles);
end
setGameControlStatus('move',handles);


% ==========================================================
% ------------------ Custom Functions ----------------------
% ==========================================================
function init_Axes(dim,handles)
%%
% Plot dim*dim*dim CUBES graph with transparent black color

dist=(dim-3)*0.3+2;
clear CUBES;
global CUBES;
CUBES = gobjects(dim,dim,dim);

% Draw CUBES using patch
cla(handles.axes3d,'reset');
vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
for x = 1:dim
    for y = 1:dim
        for z = 1:dim
            newvert = vert + ones(8,3) * (diag([x-1 y-1 z-1]) .* dist);
            CUBES(x,y,z) = patch('Vertices',newvert,...
                'Faces',fac,...
                'FaceColor',0.2*[1 1 1],...
                'ButtonDownFcn',{@cube_Callback,[x y z],handles});
            hold on;
        end
    end
end

%Visual Effects
axis off;
axis vis3d;
alpha(0.15);
camorbit(36,-72);


function rotate_Axes(direction,handles)
%%
% Rotate CUBES figure by 10 degree in specific direction
deg = 3;
switch direction
    case 'left'
        camorbit(handles.axes3d,deg,0);
    case 'right'
        camorbit(handles.axes3d,-deg,0);
    case 'up'
        camorbit(handles.axes3d,0,-deg);
    case 'down'
        camorbit(handles.axes3d,0,deg);
end

function zoom_Axes(factor,handles)
%%
% Zoom figure by factor. [-100,100]
% Zoom by setting CameraViewAngle. (0,180) default:6.6086. We use [1.5,50]
default = 6.6086;
min = 1.5;
max = 50;
if factor > 0
    angle = default - (factor/100) * (default - min);
elseif factor < 0
    angle = default + (-factor/100) * (max - default);
   
else
    angle = default;
end
set(handles.axes3d,'CameraViewAngle',angle);

function setPlayerLabels(handles)
%%
global PLAYER;
switch PLAYER
    case 1
        set(handles.player1label,'Enable','On');
        set(handles.player2label,'Enable','Off');
    case 2
        set(handles.player1label,'Enable','Off');
        set(handles.player2label,'Enable','On');
    otherwise
        disp('[Err] PLAYER not set');
end

function flashLabel(~,~,label)
%%
switch get(label,'Visible')
    case 'on'
        set(label,'Visible','off');
    case 'off'
        set(label,'Visible','on');
end

function showWinner(handles)
%%
% Show winning banner
switch isWin()
    case 1
        set(handles.winlabel,'String','Player 1 wins!','ForegroundColor','red','Visible','on');
    case 2
        set(handles.winlabel,'String','Player 2 wins!','ForegroundColor','blue','Visible','on');     
end
% Flash label
global TIMER;
TIMER = timer;
TIMER.TimerFcn = {@flashLabel,handles.winlabel};
TIMER.Period = 0.2;
TIMER.ExecutionMode = 'fixedRate';
start(TIMER);

function hideWinner(handles)
%%
global TIMER;
if isobject(TIMER) && strcmp(TIMER.Running,'on')
    stop(TIMER);
    delete(TIMER);
    clear('global','TIMER');
    set(handles.winlabel,'Visible','off');
end

function gameReset(dim,handles)
%%
% Reset variables and GUI
init_Axes(dim,handles);
initGame(dim);
setPlayerLabels(handles);
set(handles.winlabel,'Visible','off');
set(handles.zoomslider,'Value',0);
global WON;
WON = 0;

hideWinner(handles);


function highLight(obj)
%%
global CUBES;
set(CUBES,'EdgeColor','[0 0 0]','LineWidth',0.5);
set(obj,'EdgeColor','green','LineWidth',5);

function setGameControlStatus(why,handles)
%%
global HISTORY;
switch why
    case 'move'
        % After a move
        if HISTORY.last < HISTORY.top
            set(handles.redobtn,'Enable','on');
        else 
            set(handles.redobtn,'Enable','off');
        end
        if HISTORY.last > 0
            set(handles.undobtn,'Enable','on');
        else
            set(handles.undobtn,'Enable','off');
        end
    case 'reset'
        % After reset
        set(handles.redobtn,'Enable','off');
        set(handles.undobtn,'Enable','off');
end




