function varargout = CBB(varargin)
% CBB MATLAB code for CBB.fig
%      CBB, by itself, creates a new CBB or raises the existing
%      singleton*.
%
%      H = CBB returns the handle to a new CBB or the handle to
%      the existing singleton*.
%
%      CBB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CBB.M with the given input arguments.
%
%      CBB('Property','Value',...) creates a new CBB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CBB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CBB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CBB

% Last Modified by GUIDE v2.5 04-Dec-2018 21:59:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CBB_OpeningFcn, ...
                   'gui_OutputFcn',  @CBB_OutputFcn, ...
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


% --- Executes just before CBB is made visible.
function CBB_OpeningFcn(hObject, eventdata, handles, varargin)
    set(handles.select_set,'String',{'A-sets','S-sets'});
    set(handles.select_set,'Value',1);
    select_set_Callback(hObject, eventdata, handles)
    % Choose default command line output for CBB
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    % UIWAIT makes CBB wait for user response (see UIRESUME)
    uiwait(handles.CBB);


% --- Outputs from this function are returned to the command line.
function varargout = CBB_OutputFcn(hObject, eventdata, handles) 
    sel = get(handles.bOK,'UserData');
    % Get default command line output from handles structure
    varargout{1} = sel;
    CBB_CloseRequestFcn(hObject, eventdata, handles);

function CBB_CloseRequestFcn(hObject, eventdata, handles)
    if isequal(get(handles.CBB, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, use UIRESUME
        uiresume(handles.CBB);
    else
        % The GUI is no longer waiting, just close it
        delete(handles.CBB);
    end

% --- Executes on selection change in select_set.
function select_set_Callback(hObject, eventdata, handles)
    sset = get(handles.select_set,'String');
    i = get(handles.select_set,'Value');
    switch sset{i}
        case 'A-sets'
            set(handles.select_number,'String',(1:3)');
        case 'S-sets'
            set(handles.select_number,'String',(1:4)');
    end
    set(handles.select_number,'Value',1);
function select_set_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function select_number_Callback(hObject, eventdata, handles)
function select_number_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bOK_Callback(hObject, eventdata, handles)
    sset = get(handles.select_set,'String');
    i = get(handles.select_set,'Value');
    snum = get(handles.select_number,'String');
    ii = get(handles.select_number,'Value');    
    set(handles.bOK,'UserData',{'Clustering basic benchmark',sset{i},str2double(snum(ii,:))});
    CBB_OutputFcn(hObject, eventdata, handles);
    
function bCancel_Callback(hObject, eventdata, handles)
    CBB_OutputFcn(hObject, eventdata, handles); 
