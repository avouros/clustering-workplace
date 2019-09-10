function save_all(handles)
%SAVE_ALL 

    dat = get(handles.run_clustering,'UserData');
    CL_RESULTS = dat{1};
    DATA = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = get(handles.button_load,'UserData');

    % Ask for folder path and name
    prompt = {'Enter folder name:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'myresults'};
    fname = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(fname)
        return
    end
    selpath = uigetdir('','Select folder path');
    if isequal(selpath,0)
        return
    end
    ffpath = fullfile(selpath,fname{1});
    if ~exist(ffpath,'dir')
        try
            mkdir(ffpath)
        catch
            errordlg('Bad folder name.','Error');
            return
        end
    else
        q = questdlg('Folder already exists would you like to replace it?', ...
            'Replace folder','Yes','No','No');    
        if isequal(q,'Yes')
            i = rmdir(ffpath,'s');
            if i == 0
                errordlg('Cannot replace folder. It is used by another program','Error');
                return
            end
            mkdir(ffpath);
        else
            return
        end
    end
    
    % Ask if we want to extract the results in csv files
    q = questdlg('Would you like to extract the clustering results to CSV files?', ...
        'Extract to CSV','Yes','No','Yes');    
    if isequal(q,'Yes')
        flag = 1;
    else
        flag = 0;
    end    

    % Save the results in a mat file
    save(fullfile(ffpath,'cl_res'),'CL_RESULTS','DATA','PARAMS','EXTRAS','ORIGINAL_DATA');
    
    if flag
        % Headers
        dims_all = {};
        dims_sel = {};
        for i = 1:size(PARAMS.UI{1})
            str = sprintf('feature%d',i);
            dims_all = [dims_all,{str}];
            if PARAMS.UI{1}{i,3} == 1
                dims_sel = [dims_sel,{str}];
            end
        end

        % Clustering data (after normalization)
        T = array2table(DATA,'VariableNames',dims_sel);
        writetable(T,fullfile(ffpath,'data.csv'),'WriteVariableNames',1);
    
        % Original data
        T = array2table([ORIGINAL_DATA{2},ORIGINAL_DATA{1}],'VariableNames',[{'label'},dims_all]);
        writetable(T,fullfile(ffpath,'data_original.csv'),'WriteVariableNames',1);

        % Clustering info
        a = {'Normalization',PARAMS.UI{2};...
             'Initialization',PARAMS.UI{3};...
             'Clustering',PARAMS.UI{4}};
        nf = size(PARAMS.UI{1},1);
        b = cell(nf,2);
        for i = 1:nf
            b{i,1} = PARAMS.UI{1}{i,1};
            b{i,2} = num2str(PARAMS.UI{1}{i,3});
        end
        T = cell2table([a;b]);
        writetable(T,fullfile(ffpath,'info.csv'),'WriteVariableNames',0);

        % Extras
        T = array2table([EXTRAS.density,EXTRAS.ard,EXTRAS.LOF],'VariableNames',{'density','ard','lof'});
        writetable(T,fullfile(ffpath,'local_outlier_factor.csv'),'WriteVariableNames',1);    

        % Clustering results
        [ks,ss] = size(CL_RESULTS);
        for i = 1:ks
            k = PARAMS.k(i);
            for j = 1:ss
                s = PARAMS.s(j);
                %Create subfolder
                str = sprintf('k%ds%d',k,s);
                np = fullfile(ffpath,str);
                mkdir(np);
                %Extract the results
                T = array2table(CL_RESULTS(i,j).idx);
                writetable(T,fullfile(np,'assignments.csv'),'WriteVariableNames',0);
                T = array2table(CL_RESULTS(i,j).w,'VariableNames',dims_sel);
                writetable(T,fullfile(np,'featureWeights.csv'),'WriteVariableNames',1);
                T = array2table(CL_RESULTS(i,j).centers,'VariableNames',dims_sel);
                writetable(T,fullfile(np,'finalCentroids.csv'),'WriteVariableNames',1);
                T = array2table(CL_RESULTS(i,j).centers0,'VariableNames',dims_sel);
                writetable(T,fullfile(np,'initialCentroids.csv'),'WriteVariableNames',1);
            end
        end     
    end
end

