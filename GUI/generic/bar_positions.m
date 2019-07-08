function [pos,mid] = bar_positions(myData)
%BAR_POSITIONS 

    inGroupGap = 0.1;
    outGroupGap = 0.5;
    
    n = length(myData);

    pldata = [];
    pos = 0;
    tmp = 0;
    for i = 1:n
        datagroup = myData{i};
        [s1,s2] = size(datagroup);
        s0 = size(pldata,1);
        % Fix the size of the collected data or datagroup
        if i ~= 1
            if s0 < s1
                pldata = [ [pldata;NaN(s1-s0,1)] , datagroup ];
            elseif s0 > s1
                pldata = [ pldata , [datagroup;NaN(s0-s1,1)] ];
            else
                pldata = [ pldata , datagroup ];
            end    
        else
            pldata = [ pldata , datagroup ];
        end
        % Find the position of the boxes
        for j = 1:s2
            if tmp == 0
                % Same group
                pos = [pos,pos(end)+inGroupGap];
            else
                % Other group
                pos = [pos,pos(end)+outGroupGap];
                tmp = 0;
            end
        end
        tmp = 1;
    end
    pos(1) = [];
    
    % Find the middle per group
    mid = nan(1,length(pos)/s2);
    m = 1;
    for i = 1:length(mid)
        mid(i) = mean(pos(m:i*s2));
        m = m+s2;
    end
end

