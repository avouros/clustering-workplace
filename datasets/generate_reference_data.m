function randomVals = generate_reference_data(dataset,varargin)
% Generates permutations of the original dataset

% These permutation techniques are described in the study of:

% Tibshirani, Robert, Guenther Walther, and Trevor Hastie. 
% "Estimating the number of clusters in a data set via the 
% gap statistic." Journal of the Royal Statistical Society: 
% Series B (Statistical Methodology) 63.2 (2001): 411-423.



    PC = 0;      %Make the procedure rotationally invariant
    SHUFFLE = 0; %Shuffle the data of each column
    [n,m] = size(dataset); %Size of the dataset
    
    for i = 1:length(varargin)
        if isequal(varargin{i},'Deterministic')
            % Make the process deterministic
        	s = RandStream('mt19937ar','Seed',0);
            RandStream.setGlobalStream(s);
        elseif isequal(varargin{i},'Shuffling')
            % Shuffle the data of each column
            % WRSK default
            SHUFFLE = 1;
        elseif isequal(varargin{i},'PC')
            % Make the procedure rotationally invariant
            PC = 1;
        end
    end
    
    if SHUFFLE
        % Just shuffle the data of each column
        randomVals = nan(n,m);
        for i = 1:m
            tmp = randsample(dataset(:,i),n);
            randomVals(:,i) = tmp;
        end
        return
    end
    
    if PC
        % Make the procedure rotationally invariant
        % 1. Center the data around the mean
        centered = dataset - repmat(mean(dataset),n,1);
        % 2. Singular value decomposition
        [~,~,V] = svd(centered);
        dataset = centered * V;
    end
    
    % Random values in the interval [ min_d , max_d ] with:
    % - mean = (min_d+max_d)/2
    % - variance = ((max_d-min_d)^2)/12
    % Formula: a + (b-a)*rand()
    max_d = max(dataset);
    min_d = min(dataset);    
    rnd = rand(n,m);
    interval = max_d - min_d;
    clone1 = repmat(interval , n, 1);
    clone2 = repmat(min_d , n, 1);
    randomVals = clone2 + (clone1 .* rnd);

    if PC
        randomVals = randomVals * V';
    end
end