function varargout = brodinova_gui(varargin)
% BRODINOVA_GUI MATLAB code for brodinova_gui.fig
%      BRODINOVA_GUI, by itself, creates a new BRODINOVA_GUI or raises the existing
%      singleton*.
%
%      H = BRODINOVA_GUI returns the handle to a new BRODINOVA_GUI or the handle to
%      the existing singleton*.
%
%      BRODINOVA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRODINOVA_GUI.M with the given input arguments.
%
%      BRODINOVA_GUI('Property','Value',...) creates a new BRODINOVA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brodinova_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brodinova_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brodinova_gui

% Last Modified by GUIDE v2.5 21-Jun-2019 11:15:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brodinova_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @brodinova_gui_OutputFcn, ...
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


% --- Executes just before brodinova_gui is made visible.
function brodinova_gui_OpeningFcn(hObject, eventdata, handles, varargin)
    default_dataset_specs(handles);
    set(handles.plotDim1,'String','0');
    set(handles.plotDim2,'String','0');
    set(handles.plotDim3,'String','0');
    set(handles.plotDim1,'Enable','off');
    set(handles.plotDim2,'Enable','off');
    set(handles.plotDim3,'Enable','off');
    set(findall(handles.uibuttongroup3, '-property', 'enable'), 'enable', 'off')
    generate_dataset_Callback(hObject, eventdata, handles);

% Choose default command line output for brodinova_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brodinova_gui wait for user response (see UIRESUME)
uiwait(handles.brodinova_gui);


% --- Outputs from this function are returned to the command line.
function varargout = brodinova_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
brodinova_gui_CloseRequestFcn(hObject, eventdata, handles);
varargout{1} = handles.output;

function brodinova_gui_CloseRequestFcn(hObject, eventdata, handles)
    if isequal(get(handles.brodinova_gui, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, use UIRESUME
        uiresume(handles.brodinova_gui);
    else
        % The GUI is no longer waiting, just close it
        delete(handles.brodinova_gui);
    end



function generate_dataset_Callback(hObject, eventdata, handles)
    [F,group_sizes,p_info,p_noise,...
        pn_info,pp_info,pn_noise,pp_noise,...
        groups_mu_range,groups_rho_range,out_unif_range,...
        out_scatter_range,out_noise_range,scatter_out,MINDIST] = collect_dataset_specs(handles);
    
    if ~F
        return
    end
    
    %deterministic results
    d = get(handles.deterministic_results,'Value');
    if d == 1
        [x,y,lb1,lb_out] = brodinova('dataset',group_sizes,'p_info',p_info,'p_noise',p_noise,...
                            'groups_mu_range',groups_mu_range,'groups_rho_range',groups_rho_range,...
                            'pn_info',pn_info,'pp_info',pp_info,'pn_noise',pn_noise,'pp_noise',pp_noise,...
                            'out_unif_range',out_unif_range,'out_scatter_range',out_scatter_range,...
                            'out_noise_range',out_noise_range,'scatter_out',scatter_out,'MINDIST',MINDIST,'deterministic');  
    else
        [x,y,lb1,lb_out] = brodinova('dataset',group_sizes,'p_info',p_info,'p_noise',p_noise,...
                            'groups_mu_range',groups_mu_range,'groups_rho_range',groups_rho_range,...
                            'pn_info',pn_info,'pp_info',pp_info,'pn_noise',pn_noise,'pp_noise',pp_noise,...
                            'out_unif_range',out_unif_range,'out_scatter_range',out_scatter_range,...
                            'out_noise_range',out_noise_range,'scatter_out',scatter_out,'MINDIST',MINDIST);        
    end
                    
    collect = {group_sizes;p_info;p_noise;groups_mu_range;groups_rho_range;...
                pn_info;pp_info;pn_noise;pp_noise;scatter_out;...
                out_unif_range;out_scatter_range;out_noise_range;MINDIST};

    set(handles.generate_dataset,'UserData',collect);
    set(handles.save_dataset,'UserData',{x,y,lb1,lb_out});
    
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
    plotDim1_Callback(hObject, eventdata, handles);
    
    
function save_dataset_Callback(hObject, eventdata, handles)    
    collect = get(handles.generate_dataset,'UserData');
    tmp =  get(handles.save_dataset,'UserData');
    if isempty(collect) || isempty(tmp)
        return
    end
    x = tmp{1};
    y = tmp{2};
    lb1 = tmp{3};
    lb_out = tmp{4};
    info1 = {'group_sizes';'p_info';'p_noise';'groups_mu_range';'groups_rho_range';...
        'pn_info';'pp_info';'pn_noise';'pp_noise';'scatter_out';...
        'out_unif_range';'out_scatter_range';'out_noise_range';'MINDIST'};
    info = [info1,collect];
    uisave({'x','y','lb1','lb_out','info'},'synthData');


function nsizes_Callback(hObject, eventdata, handles)
function nsizes_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_info_Callback(hObject, eventdata, handles)
function variables_info_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_noise_Callback(hObject, eventdata, handles)
function variables_noise_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_info_Callback(hObject, eventdata, handles)
function variables_out_info_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_noise_Callback(hObject, eventdata, handles)
function variables_out_noise_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_info_per_Callback(hObject, eventdata, handles)
function variables_out_info_per_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_noise_per_Callback(hObject, eventdata, handles)
function variables_out_noise_per_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_info_mu1_Callback(hObject, eventdata, handles)
function range_info_mu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_mu_Callback(hObject, eventdata, handles)
function variables_out_mu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_info_si1_Callback(hObject, eventdata, handles)
function range_info_si1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function variables_out_si_Callback(hObject, eventdata, handles)
function variables_out_si_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit17_Callback(hObject, eventdata, handles)
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_noise_out_mu1_Callback(hObject, eventdata, handles)
function range_noise_out_mu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_noise_out_si1_Callback(hObject, eventdata, handles)
function range_noise_out_si1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_noise_out_mu2_Callback(hObject, eventdata, handles)
function range_noise_out_mu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_noise_out_si2_Callback(hObject, eventdata, handles)
function range_noise_out_si2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_unif_out_mu1_Callback(hObject, eventdata, handles)
function range_unif_out_mu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_unif_out_si1_Callback(hObject, eventdata, handles)
function range_unif_out_si1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_unif_out_mu2_Callback(hObject, eventdata, handles)
function range_unif_out_mu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_unif_out_si2_Callback(hObject, eventdata, handles)
function range_unif_out_si2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_scatter_out_mu_Callback(hObject, eventdata, handles)
function range_scatter_out_mu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_scatter_out_si_Callback(hObject, eventdata, handles)
function range_scatter_out_si_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_info_mu2_Callback(hObject, eventdata, handles)
function range_info_mu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function range_info_si_Callback(hObject, eventdata, handles)
function range_info_si_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sel_scattered_Callback(hObject, eventdata, handles)
    set(handles.range_scatter_out_mu,'Enable','on');
    set(handles.range_unif_out_mu1,'Enable','off');
    set(handles.range_unif_out_mu2,'Enable','off');
function sel_uniform_Callback(hObject, eventdata, handles)
    set(handles.range_scatter_out_mu,'Enable','off');
    set(handles.range_unif_out_mu1,'Enable','on');
    set(handles.range_unif_out_mu2,'Enable','on');

function default_values_Callback(hObject, eventdata, handles)
    default_dataset_specs(handles);
    

%% PLOTTING
function plotDim1_Callback(hObject, eventdata, handles)
    a = get(handles.save_dataset,'UserData');
    plot_dataset(a{1},a{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);
function plotDim1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotDim2_Callback(hObject, eventdata, handles)
    a = get(handles.save_dataset,'UserData');
    plot_dataset(a{1},a{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);
function plotDim2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plotDim3_Callback(hObject, eventdata, handles)
    a = get(handles.save_dataset,'UserData');
    plot_dataset(a{1},a{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);
function plotDim3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function generate_new_figure_Callback(hObject, eventdata, handles)
    a = get(handles.save_dataset,'UserData');
    plot_dataset(a{1},a{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);

    
function uniformative_options_Callback(hObject, eventdata, handles)
function uniformative_options_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function deterministic_results_Callback(hObject, eventdata, handles)






%%
function [F, group_size,p_info,p_noise,...
    pn_info,pp_info,pn_noise,pp_noise,...
    groups_mu_range,groups_rho_range,out_unif_range,...
    out_scatter_range,out_noise_range,scatter_out,MINDIST] = collect_dataset_specs(handles)

    F = 0;
    
    %dataset size and groups
    group_size = abs(str2num(get(handles.nsizes,'String')));
    if isempty(group_size) || ~isempty(find(isnan(group_size))) || ~isempty(find(group_size==0))
        errordlg('Group sizes: insert nonzero positive numeric values separated by commas.')
        return
    end
    
    %number of informative variables
    p_info = abs(str2double(get(handles.variables_info,'String')));
    if isempty(p_info) || ~isempty(find(isnan(p_info))) 
        errordlg('Attributes, informative: insert zero or positive numeric value.');
        return
    end    
    %number of uninformative variables
    p_noise = abs(str2double(get(handles.variables_noise,'String')));
    if isempty(p_noise) || ~isempty(find(isnan(p_noise))) 
        errordlg('Attributes, uninformative: insert zero or positive numeric value.');
        return
    end        
    if p_info == 0 && p_noise == 0
        errordlg('Attributes: the dataset needs to have at least one informative or uninformative variable');
        return
    end
    
    if length(group_size) > p_info+p_noise+1
        warndlg('The total number of groups should be less than the total number of variables +1 or else some groups might be too similar.');
        return
    end

    %number of informative variables contaminated with outliers (p_out_inf)
    %(0 or negative means all)
    pn_info = str2double(get(handles.variables_out_info,'String'));
    if isempty(pn_info) || ~isempty(find(isnan(pn_info))) 
        errordlg('Outliers, informative: insert numeric value, 0 or negative means all');
        return
    end      
    %proportion of observations to be contaminated in the informative variables (pct_out)
    %(0 or negative nullifies pn_info)
    pp_info = str2double(get(handles.variables_out_info_per,'String'));
    if isempty(pp_info) || ~isempty(find(isnan(pp_info))) || pp_info > 100
        errordlg('Outliers, informative %: insert numeric value less or equal to 100, 0 or negative means that no informative variables will be contaminated');
        return
    end      
    pp_info = pp_info / 100;
    %number of uninformative variables contaminated with outliers (p_out_noise)
    %(0 or negative means all)
    pn_noise = str2double(get(handles.variables_out_noise,'String'));
    if isempty(pn_noise) || ~isempty(find(isnan(pn_noise))) 
        errordlg('Outliers, uninformative: insert numeric value, 0 or negative means all');
        return
    end        
    %proportion of observations to be contaminated in the uninformative variables
    %(0 or negative nullifies pn_noise)
    pp_noise = str2double(get(handles.variables_out_noise_per,'String'));
    if isempty(pp_noise) || ~isempty(find(isnan(pp_noise))) || pp_noise > 100
        errordlg('Outliers, uninformative %: insert numeric value less or equal to 100, 0 or negative means that no uninformative variables will be contaminated');
        return
    end     
    pp_noise = pp_noise / 100;

    %informative variables mu range; each row: [min,max]
    groups_mu_range1 = str2num(get(handles.range_info_mu1,'String'));
    groups_mu_range2 = str2num(get(handles.range_info_mu2,'String'));
    groups_mu_range  = [groups_mu_range1 ; groups_mu_range2];
    if isempty(groups_mu_range) || ~isempty(find(isnan(groups_mu_range))) || length(groups_mu_range) ~= 2
        errordlg('Attributes, informative ranges ?: insert two numeric values per field separated with commas');
        return
    end     
    %covariance matrix, off-diagonal elements; each row: [min,max]
    groups_rho_range = str2num(get(handles.range_info_si,'String'));  
    if isempty(groups_rho_range) || ~isempty(find(isnan(groups_rho_range))) || length(groups_mu_range) ~= 2
        errordlg('Attributes, informative ranges ?: insert two numeric values separated with comma');
        return
    end     
    
    a = get(handles.sel_scattered,'Value');
    b = get(handles.sel_uniform,'Value');
    if a == 1
        %scattered outliers are generated with the characteristics specified in out_scatter_range
        %informative variales; outliers, scatterd; each row: [min,max]
        out_scatter_range = str2num(get(handles.range_scatter_out_mu,'String')); 
        scatter_out = 1;
        if isempty(out_scatter_range) || ~isempty(find(isnan(out_scatter_range))) || length(out_scatter_range) ~= 2
            errordlg('Outliers, informative ranges scattered: insert two numeric values separated with comma');
            return
        end       
        out_unif_range = [-12,6;6,12];
    elseif b == 1
        %uniformly distributed outliers are produced with the specification defined in out_unif_range
        %informative variales; outliers, uniformly distributed; each row: [min,max]
        out_unif_range1 = str2num(get(handles.range_unif_out_mu1,'String'));
        out_unif_range2 = str2num(get(handles.range_unif_out_mu2,'String'));
        out_unif_range  = [out_unif_range1;out_unif_range2];    
        scatter_out = 0;
        if isempty(out_unif_range) || ~isempty(find(isnan(out_unif_range))) || length(out_unif_range) ~= 2
            errordlg('Outliers, informative ranges uniform: insert two numeric values per field separated with commas');
            return
        end       
        out_scatter_range = [3,10];
    else
        error('DEBUG: collect_dataset_specs: line 94');
    end
    %uninformative variales; outliers, uniformly distributed; each row: [min,max]
    out_noise_range1 = str2num(get(handles.range_noise_out_mu1,'String'));
    out_noise_range2 = str2num(get(handles.range_noise_out_mu2,'String'));
    out_noise_range  = [out_noise_range1;out_noise_range2]; 
    if isempty(out_noise_range) || ~isempty(find(isnan(out_noise_range))) || length(out_noise_range) ~= 2
        errordlg('Outliers, uninformative ranges: insert two numeric values per field separated with commas');
        return
    end          

    %separation
    MINDIST = str2num(get(handles.separated_points,'String'));
    if isempty(MINDIST) || ~isempty(find(isnan(MINDIST))) || length(MINDIST) ~= 1
        errordlg('Separation: insert a numeric value');
        return
    end
    
    F = 1;

    
%%
function default_dataset_specs(handles)

    % Datapoints
    %length: number of groups, numbers: points of each group
    group_sizes = [40,40,40]; 

    % Variables / Attributes
    %number of informative variables
    p_info = 50;   
    %number of uninformative variables
    p_noise = 750;   
    %informative variables mu range; each row: [min,max]
    groups_mu_range = [-6,-3;3,6]; 
    %covariance matrix, off-diagonal elements; each row: [min,max]
    groups_rho_range = [0.1,0.9];  

    % Variable outliers
    %number of informative variables contaminated with outliers (p_out_inf)
    pn_info = 0;     %(0 or negative means all)          
    %proportion of observations to be contaminated in the informative variables (pct_out)
    pp_info = 0.1*100;   %(0 or negative nullifies pn_info). 
    %number of uninformative variables contaminated with outliers (p_out_noise)
    pn_noise = 75;   %(0 or negative means all)
    %proportion of observations to be contaminated in the uninformative variables.
    pp_noise = 0.1*100; %(0 or negative nullifies pn_noise). 

    % Scatter outliers
    %1: scattered outliers are generated with the characteristics specified in out_scatter_range
    %0: uniformly distributed outliers are produced with the specification defined in out_unif_range
    scatter_out = 1; 

    %% Ranges
    %informative variales; outliers, uniformly distributed; each row: [min,max]
    out_unif_range = [-12,6;6,12];  
    %informative variales; outliers, scatterd; each row: [min,max]
    out_scatter_range = [3,10];     
    %uninformative variales; outliers, uniformly distributed; each row: [min,max]
    out_noise_range = [-12,6;6,12]; 
    
    %% Separation
    separate = 0;

    
    %% Update GUI
    set(handles.nsizes,'String',strjoin(arrayfun(@(x) num2str(x),group_sizes,'UniformOutput',false),','));
    set(handles.variables_info,'String',p_info);
    set(handles.variables_noise,'String',p_noise);
    set(handles.variables_out_info,'String',pn_info);
    set(handles.variables_out_info_per,'String',pp_info);
    set(handles.variables_out_noise,'String',pn_noise);
    set(handles.variables_out_noise_per,'String',pp_noise);
    set(handles.range_info_mu1,'String',strjoin(arrayfun(@(x) num2str(x),groups_mu_range(1,:),'UniformOutput',false),','));
    set(handles.range_info_mu2,'String',strjoin(arrayfun(@(x) num2str(x),groups_mu_range(2,:),'UniformOutput',false),','));
    set(handles.range_info_si,'String',strjoin(arrayfun(@(x) num2str(x),groups_rho_range,'UniformOutput',false),','));
    set(handles.range_scatter_out_mu,'String',strjoin(arrayfun(@(x) num2str(x),out_scatter_range,'UniformOutput',false),','));
    set(handles.range_unif_out_mu1,'String',strjoin(arrayfun(@(x) num2str(x),out_unif_range(1,:),'UniformOutput',false),','));
    set(handles.range_unif_out_mu2,'String',strjoin(arrayfun(@(x) num2str(x),out_unif_range(2,:),'UniformOutput',false),','));
    set(handles.range_noise_out_mu1,'String',strjoin(arrayfun(@(x) num2str(x),out_noise_range(1,:),'UniformOutput',false),','));
    set(handles.range_noise_out_mu2,'String',strjoin(arrayfun(@(x) num2str(x),out_noise_range(2,:),'UniformOutput',false),','));
    
    set(handles.sel_scattered,'Value',1);
    set(handles.sel_uniform,'Value',0); 
    set(handles.range_scatter_out_mu,'Enable','on');
    set(handles.range_unif_out_mu1,'Enable','off');
    set(handles.range_unif_out_mu2,'Enable','off');   
    
    set(handles.separated_points,'String',separate);



function separated_points_Callback(hObject, eventdata, handles)
function separated_points_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
