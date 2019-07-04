function [cm,acc,accpc] = confusionmatrix(true_values, predicted_values)
%CONFUSIONMATRIX calculates the confusion matrix given true and predicted
%classes.

% INPUT:
%  true_values: data labels (vector)
%  predicted_values: clustering results (vector)

% OUTPUT:
%  cm: confusion matrix; diagonal elements are the correct decisions,
%      columns are the predicted classes and rows are the true classes.
%  acc: overall classification accuracy (percentage).
%  accpc: classification accuracy per class (percentages); the first column
%         specifies the class and the second the accuracy of predicting
%         that class.


    if size(true_values) ~= size(predicted_values)
        error('confusionmatrix error: vectors of true and predicted values needs to have the same size');
    end

    g = unique(true_values);   %true labels
    ng = length(g);
    gh = unique(predicted_values); %predicted labels
    ngh = length(gh);

    cm = zeros(ng,ngh);   %init the confusion matrix
    accpc = [g,zeros(ng,1)];
    

    for i = 1:ng
        %find elements of class g(i)
        lab = find(true_values == g(i));
        %find elements classified as g(i)
        clu = find(predicted_values == g(i));
        %find number of correctly classified elements (diagonal)
        inter = intersect(lab,clu);
        cm(i,i) = length(inter);
        
        %find wrongly classified elements
        setdiff_ = setdiff(lab,clu);
        tmp = predicted_values(setdiff_);
        %find the assigned class of the wrongly classified elements
        utmp = unique(tmp);
        for z = 1:length(utmp)
            cm(i,utmp(z)) = length(find(tmp==utmp(z)));
        end
        
        %compute the accuracy per class
        accpc(i,2) = cm(i,i)*100 / sum(cm(i,:));
    end
    
    %compute overall accuracy
    acc = mean(accpc(:,2),1);
end