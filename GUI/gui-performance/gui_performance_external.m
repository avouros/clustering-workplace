function varargout = gui_performance_external(varargin)
% GUI_PERFORMANCE_EXTERNAL MATLAB code for gui_performance_external.fig
%      GUI_PERFORMANCE_EXTERNAL, by itself, creates a new GUI_PERFORMANCE_EXTERNAL or raises the existing
%      singleton*.
%
%      H = GUI_PERFORMANCE_EXTERNAL returns the handle to a new GUI_PERFORMANCE_EXTERNAL or the handle to
%      the existing singleton*.
%
%      GUI_PERFORMANCE_EXTERNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PERFORMANCE_EXTERNAL.M with the given input arguments.
%
%      GUI_PERFORMANCE_EXTERNAL('Property','Value',...) creates a new GUI_PERFORMANCE_EXTERNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_performance_external_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_performance_external_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_performance_external

% Last Modified by GUIDE v2.5 11-Jul-2019 00:04:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_performance_external_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_performance_external_OutputFcn, ...
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


% --- Executes just before gui_performance_external is made visible.
function gui_performance_external_OpeningFcn(hObject, eventdata, handles, varargin)
    if length(varargin) == 0
        error('No data');
    else
        set(handles.refresh_plots,'UserData',varargin{1});
    end

    % Compute the indexes
    h = waitbar(0,'Computing external indexes...','Name','Loading');
    dat = get(handles.refresh_plots,'UserData');
    CL_RESULTS = dat{1};
    DATA = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = dat{5};
    [n,p] = size(DATA);
    Ks = PARAMS.k;
    Ss = PARAMS.s;
    tmp = length(unique(ORIGINAL_DATA{2}));
    if isempty(find(Ks==tmp))
        errordlg('Cannot compute external clustering indexes because the clustering with the true number of clusters is unavailable.','Error');
        delete(h);
        handles.output = hObject;
        guidata(hObject, handles);        
        gui_performance_external_CloseRequestFcn(hObject, eventdata, handles);
        return
    else
        res = CL_RESULTS(find(Ks==tmp),:);
    end
    PERF_EXTER = performance_external_simple(ORIGINAL_DATA{2},res);
    set(handles.gui_performance_external,'UserData',PERF_EXTER);
    delete(h);
    
    % Table: active_indexExt
    str = fieldnames(PERF_EXTER);
    nfields = size(str,1);
    act = num2cell(logical(zeros(nfields,1)));
    str_c = cell(nfields,1);
    colors = color_fullhue(nfields);    
    for i = 1:nfields
        color = dec2hex(round(colors(i,:).*255));
        color = ['#',color(1,:),color(2,:),color(3,:)];
        str_tmp = num2str(colors(i,:)); %str2num should be used to get the color
        str_c{i} = strcat(['<html><body bgcolor="' color '" font color="' color '" text="' str_tmp '" width="80px">'], color);
    end
    act{1} = true;
    t = [str,str_c,act];
    set(handles.active_indexExt,'Data',t);   
    
    % Update the GUI
    gui_performance_external_update(handles);    
    default_gui_options(handles) %dafault gui options
    % Choose default command line output for gui_performance_external
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    % UIWAIT makes gui_performance_external wait for user response (see UIRESUME)
    % uiwait(handles.gui_performance_external);


% --- Outputs from this function are returned to the command line.
function varargout = gui_performance_external_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in refresh_plots.
function refresh_plots_Callback(hObject, eventdata, handles)
    gui_performance_external_update(handles);    


% --- Executes when user attempts to close gui_performance_external.
function gui_performance_external_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to gui_performance_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object deletion, before destroying properties.
function gui_performance_external_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to gui_performance_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
