function varargout = clustering_gui(varargin)
% CLUSTERING_GUI MATLAB code for clustering_gui.fig
%      CLUSTERING_GUI, by itself, creates a new CLUSTERING_GUI or raises the existing
%      singleton*.
%
%      H = CLUSTERING_GUI returns the handle to a new CLUSTERING_GUI or the handle to
%      the existing singleton*.
%
%      CLUSTERING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTERING_GUI.M with the given input arguments.
%
%      CLUSTERING_GUI('Property','Value',...) creates a new CLUSTERING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before clustering_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to clustering_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help clustering_gui

% Last Modified by GUIDE v2.5 10-Jul-2019 23:27:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @clustering_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @clustering_gui_OutputFcn, ...
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


% --- Executes just before clustering_gui is made visible.
function clustering_gui_OpeningFcn(hObject, eventdata, handles, varargin)
    addpath(genpath(pwd)); %add everything to the MATLAB path
    gui_opening(handles);  %initialize gui
    default_gui_options(handles) %dafault gui options
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to clustering_gui (see VARARGIN)
    % Choose default command line output for clustering_gui
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    % UIWAIT makes clustering_gui wait for user response (see UIRESUME)
    % uiwait(handles.clustering_gui);


% --- Outputs from this function are returned to the command line.
function varargout = clustering_gui_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    
%% LOAD DATASET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function button_load_Callback(hObject, eventdata, handles)
    % Load the dataset
    set(handles.clustering_gui,'Visible','off');
    switch class(hObject)
        case 'matlab.ui.control.UIControl'
            [x,y,lb1,lb_out,str] = load_dataset;       
        case 'cell'
            % Clustering basic benchmark, Yan and Ye
            [x,y,lb1,lb_out,str] = load_dataset(hObject);
        otherwise
            set(handles.clustering_gui,'enable','on');
            error('Wrong object');
    end
    set(handles.clustering_gui,'Visible','on');
    if isempty(x)
        % Leave everything as they are with the previous dataset, if any
        return
    end
    %cla(handles.plot_performance,'reset');
    %cla(handles.plot_weights,'reset');    
    set(handles.button_load,'UserData',{x,y,lb1,lb_out,str});
    set(findall(handles.panel_clustering, '-property', 'enable'), 'enable', 'on');
    set(handles.save_clustering,'enable','off');
    set(handles.plotDim1,'enable','on');
    set(handles.plotDim2,'enable','on');
    set(handles.plotDim3,'enable','on');
    set(handles.dataset_norm,'enable','on');    
    % Update GUI
    set(handles.run_clustering,'UserData','');
    gui_update(handles)    
    activate_s(hObject, eventdata, handles)
    % Plot
    plot_dataset(x,y,handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);
function features_properties_Callback(hObject, eventdata, handles)
    p = get(handles.features_properties,'String');
    i = get(handles.features_properties,'Value');
    p = str2num(p(i,:));
    x_labs = get(handles.button_load,'UserData');
    x = x_labs{1};
    x_labs = x_labs{2};
    c = unique(x_labs);
    mnx = get(handles.dataset_norm,'String');
    i = get(handles.dataset_norm,'Value');    
    x = normalizations(x,mnx{i});    
    tickxl = [num2cell(c);'all'];
    color_box = repmat({'white'},1,length(c));
    color_box = [{'black'},color_box];
    color_median = repmat({'black'},1,length(c));
    color_median = [{'white'},color_median];
    t = sprintf('Feature %d',p);
    % Features values per class
    stratsFeats = cell(1,length(c)+1);
    for j = 1:length(c)
        stratsFeats{1,j} = x(x_labs==c(j),p);
    end    
    stratsFeats{1,length(c)+1} = x(:,p);
    % Make the plot
    NewF = findobj('type','figure','tag','NewF');
    if exist('NewF','var') && ~get(handles.hold_features_properties,'Value')
        close(NewF);
    end
    NewF = customBoxplot(stratsFeats,'maximize_figure',0,'Visible','off',...
          'Xlabel','classes / clusters','Ylabel','feature values','Title',t,'tickxl',tickxl,...
          'color_box',color_box,'color_median',color_median);
    set(NewF,'Visible','on');
    
% Sparsity parameter options are needed only for Sparse clustering    
function activate_s(hObject, eventdata, handles)
    tmp = get(handles.init_clustering,'String');
    v = get(handles.init_clustering,'Value');
    switch tmp{v}
        case 'Sparse K-Means'
            set(handles.s_start,'enable','on');    
            set(handles.s_end,'enable','on');    
            set(handles.s_step,'enable','on');    
        otherwise
            set(handles.s_start,'enable','off');    
            set(handles.s_end,'enable','off');    
            set(handles.s_step,'enable','off');                
    end

 
    
%% PLOT DATASET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function features_properties_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotDim1_Callback(hObject, eventdata, handles)
    data = get(handles.button_load,'UserData');
    plot_dataset(data{1},data{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);
function plotDim1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotDim2_Callback(hObject, eventdata, handles)
    data = get(handles.button_load,'UserData');
    plot_dataset(data{1},data{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);   
function plotDim2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotDim3_Callback(hObject, eventdata, handles)
    data = get(handles.button_load,'UserData');
    plot_dataset(data{1},data{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);   
function plotDim3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dataset_norm_Callback(hObject, eventdata, handles)
    data = get(handles.button_load,'UserData');
    plot_dataset(data{1},data{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);           
function dataset_norm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function generate_new_figure_Callback(hObject, eventdata, handles)
    data = get(handles.button_load,'UserData');
    plot_dataset(data{1},data{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure,handles.dataset_norm);       
function hold_features_properties_Callback(hObject, eventdata, handles)



%% CLUSTER DATASET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_clustering_Callback(hObject, eventdata, handles) 
    % Get user options
    [method_norm,method_centers,method_cluster,x,KS,SS] = collect_options(handles);
    % Disable the GUI
    myGUI = findobj(handles.clustering_gui,'Enable','on');
    set(myGUI,'Enable','off'); 
    pause(0.005)
    % Execute clustering
    [CL_RESULTS,DATA,PARAMS,EXTRAS] = clustering_exe(method_norm,method_centers,method_cluster,x,KS,SS);
    if ~isempty(find(arrayfun(@(x) isempty(x.w), CL_RESULTS)==1))
        % Reset the clustering was not complete
        myGUI = findobj(handles.clustering_gui,'Enable','off');
        set(myGUI,'Enable','on');     
        activate_s(hObject, eventdata, handles);
        set(handles.results_pop,'Enable','off');
        return
    end
    fdata = get(handles.dataset_feats,'Data');
    PARAMS.UI = {fdata,method_norm,method_centers,method_cluster};
    ORIGINAL_DATA = get(handles.button_load,'UserData');
    set(handles.run_clustering,'UserData',{CL_RESULTS,DATA,PARAMS,EXTRAS,ORIGINAL_DATA});
    % Re-activate GUI
    myGUI = findobj(handles.clustering_gui,'Enable','off');
    set(myGUI,'Enable','on');   
    if size(ORIGINAL_DATA{1},2) == 1
        set(handles.plotDim2,'enable','off');
        set(handles.plotDim3,'enable','off');
    elseif size(ORIGINAL_DATA{1},2) == 2
        set(handles.plotDim3,'enable','off');
    end
    activate_s(hObject, eventdata, handles)
    
function save_clustering_Callback(hObject, eventdata, handles)
    dat = get(handles.run_clustering,'UserData');
    CL_RESULTS = dat{1};
    DATA = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = get(handles.button_load,'UserData');
    uisave({'CL_RESULTS','DATA','PARAMS','EXTRAS','ORIGINAL_DATA'},'cl_res');
    

%% RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function load_clustering_Callback(hObject, eventdata, handles)
    % Load clustering results from this GUI
    err = load_CLRES(handles);  
    if err == 1
        return
    end
    %gui_update(handles) 
    activate_s(hObject, eventdata, handles);    
function results_pop_Callback(hObject, eventdata, handles)
    gui_results(handles,eventdata);
function results_pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end    
    
    
%% MENU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function load_more_data_Callback(hObject, eventdata, handles)
function dCBB_Callback(hObject, eventdata, handles)
    % Clustering basic benchmark datasets
    set(handles.clustering_gui,'Visible','off');
    outVar = CBB;
    set(handles.clustering_gui,'Visible','on');
    if isempty(outVar)
    	return
    else
        button_load_Callback(outVar, eventdata, handles);
    end
function dBrodinova_Callback(hObject, eventdata, handles)
    set(handles.clustering_gui,'Visible','off');
    brodinova_gui;
    set(handles.clustering_gui,'Visible','on');
function dYY_Callback(hObject, eventdata, handles)
    list = {'Model 1','Model 2','Model 3','Model 4','Model 5','Model 6'};
    indx = listdlg('ListString',list,'SelectionMode','single'); 
    button_load_Callback({'Yan and Ye',indx}, eventdata, handles);
function dGap_Callback(hObject, eventdata, handles)
    list = {'Model 1','Model 2','Model 3','Model 4','Model 5'};
    indx = listdlg('ListString',list,'SelectionMode','single'); 
    button_load_Callback({'Gap',indx}, eventdata, handles);    

    
    
 %% OTHER GUI PARTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function init_norm_Callback(hObject, eventdata, handles)
function init_norm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function init_centers_Callback(hObject, eventdata, handles)
function init_centers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function init_clustering_Callback(hObject, eventdata, handles)
    activate_s(hObject, eventdata, handles)
function init_clustering_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function corrk_Callback(hObject, eventdata, handles)
function corrk_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function corrc_Callback(hObject, eventdata, handles)
function corrc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end    
function s_step_Callback(hObject, eventdata, handles)
function s_step_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function s_end_Callback(hObject, eventdata, handles)
function s_end_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function s_start_Callback(hObject, eventdata, handles)
function s_start_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_start_Callback(hObject, eventdata, handles)
function k_start_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_end_Callback(hObject, eventdata, handles)
function k_end_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_step_Callback(hObject, eventdata, handles)
function k_step_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end   
