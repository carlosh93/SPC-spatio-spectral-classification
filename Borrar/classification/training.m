function trn_indx = training (labs, num_smp)  
%% Dictionary of classes
clss      = unique(labs(:)); 
num_clss  = length(clss);

dicc      = [];
for itr = 1:num_clss
    idx   = find(labs(:) == clss(itr));
    if length(idx) < num_smp
        dicc   = [dicc; idx(randperm(length(idx)))];
    else
        dicc   = [dicc; idx(randperm(length(idx), num_smp))];
    end
end
trn_indx        = dicc;