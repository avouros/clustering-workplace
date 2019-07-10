function varargout = plotter_init_centers(varargin)
% PLOTTER_INIT_CENTERS MATLAB code for plotter_init_centers.fig
%      PLOTTER_INIT_CENTERS, by itself, creates a new PLOTTER_INIT_CENTERS or raises the existing
%      singleton*.
%
%      H = PLOTTER_INIT_CENTERS returns the handle to a new PLOTTER_INIT_CENTERS or the handle to
%      the existing singleton*.
%
%      PLOTTER_INIT_CENTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTTER_INIT_CENTERS.M with the given input arguments.
%
%      PLOTTER_INIT_CENTERS('Property','Value',...) creates a new PLOTTER_INIT_CENTERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotter_init_centers_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotter_init_centers_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotter_init_centers

% Last Modified by GUIDE v2.5 15-Dec-2018 11:46:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotter_init_centers_OpeningFcn, ...
                   'gui_OutputFcn',  @plotter_init_centers_OutputFcn, ...
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


% --- Executes just before plotter_init_centers is made visible.
function plotter_init_centers_OpeningFcn(hObject, eventdata, handles, varargin)
    if length(varargin) == 0
        error('No data');
    else
        set(handles.plotter_init_centers,'UserData',varargin{1});
    end
    
    dat = get(handles.plotter_init_centers,'UserData');
    CL_RESULTS = dat{1};
    x = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = dat{5};
    
    set(handles.dataset_norm,'String',PARAMS.k);
    set(handles.dataset_norm,'Value',1);
    set(handles.dataset_sparsity,'String',PARAMS.s);
    set(handles.dataset_sparsity,'Value',1);
    if length(PARAMS.s) == 1 && PARAMS.s(1) == 0
        set(handles.dataset_sparsity,'Enable','off');
    end

    set(handles.generate_new_figure,'Enable','on');
    set(handles.plotDim1,'Enable','on');
    set(handles.plotDim1,'String',num2str(1));
    set(handles.plotDim2,'String',num2str(0));
    set(handles.plotDim3,'String',num2str(0));
    set(handles.plotDim1,'Value',1);
    set(handles.plotDim2,'Value',1);   
    set(handles.plotDim3,'Value',1); 
    set(handles.plotDim2,'Enable','off');
    set(handles.plotDim3,'Enable','off'); 
    if size(x,2) > 1
        set(handles.plotDim2,'Enable','on');
        set(handles.plotDim1,'String',['1';'2']);
        set(handles.plotDim2,'String',['1';'2']);
        set(handles.plotDim1,'Value',1);
        set(handles.plotDim2,'Value',2);        
    end
    if size(x,2) > 2
        set(handles.plotDim3,'Enable','on');    
        set(handles.plotDim1,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim2,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim3,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim1,'Value',1);
        set(handles.plotDim2,'Value',2);  
        set(handles.plotDim3,'Value',3);  
    end   
    set(handles.generate_new_figure,'Value',0);  
    set(handles.show_init_centers,'Value',1);  
    set(handles.show_final_centers,'Value',0);  
    set(handles.show_final_clusters,'Value',0); 
    try
        set(handles.dataset_norm,'UserData',CL_RESULTS(1,1).centers0);
    catch
        plotter_init_centers_CloseRequestFcn(hObject, eventdata, handles);
        return
    end
    collect_and_plot(handles)

    default_gui_options(handles) %dafault gui options
    
    % Choose default command line output for plotter_init_centers
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes plotter_init_centers wait for user response (see UIRESUME)
    % uiwait(handles.plotter_init_centers);


% --- Outputs from this function are returned to the command line.
function varargout = plotter_init_centers_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];

function plotter_init_centers_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);


function plotDim1_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function plotDim1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function plotDim2_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function plotDim2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function plotDim3_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function plotDim3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dataset_norm_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function dataset_norm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dataset_sparsity_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function dataset_sparsity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function generate_new_figure_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function show_init_centers_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function show_final_centers_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);
function show_final_clusters_Callback(hObject, eventdata, handles)
    collect_and_plot(handles);



function collect_and_plot(handles)
    dat = get(handles.plotter_init_centers,'UserData');
    CL_RESULTS = dat{1};
    x = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = dat{5};

    str = get(handles.dataset_norm,'String');
    i = get(handles.dataset_norm,'Value');
    numk = str2double(str(i,:));
    nums = get(handles.dataset_sparsity,'Value');    
    % Show initial centers
    if get(handles.show_init_centers,'Value') == 1
        set(handles.dataset_norm,'UserData',CL_RESULTS(numk,1).centers0);
    else
        set(handles.dataset_norm,'UserData',[]);
    end
    % Show final centers
    if get(handles.show_final_centers,'Value') == 1
        y = CL_RESULTS(numk,nums).idx;
        final_centers = clustering_metrics(x,y,'Weights',CL_RESULTS(numk,nums).w);
        w = repmat(CL_RESULTS(numk,nums).w,size(x,1),1);
        x = x.*w;        
    else
        final_centers = [];
    end   
    % Show final clusters
    if get(handles.show_final_clusters,'Value') == 1
        y = CL_RESULTS(numk,nums).idx;
    else
        y = ones(size(x,1),1);
    end
    plot_dataset(x,y,handles.plot_dataset2,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm,final_centers);
