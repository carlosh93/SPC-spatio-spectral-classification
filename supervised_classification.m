function [rstl] = supervised_classification(data_lbls,trng,M,N,L,type,params)

if type==1
    D = params{1};
    Da = params{2};
    FIR = params{3};
    
    tic;         % start time counting
    [trn_indx,~] = data_training(data_lbls,trng,true); %test_indx
    trn_indx = trn_indx(:,1);
    
    F_est = Da'*FIR;
    tmp1          = normc(FIR')';
    tmp2          = normc(F_est(trn_indx, :)')';
    %SVM - Proposed Method
    t             = templateSVM('Standardize',1,'BoxConstraint',3);
    Md1_svm       = fitcecoc(tmp2,data_lbls(trn_indx),'Learners',t);
    est_labs_svm  = predict(Md1_svm,tmp1);
    full_labs_svm = uint8(D'*double(est_labs_svm));
    rstl.svm_rstl = evaluate_results(full_labs_svm(data_lbls~=0),...
        data_lbls(data_lbls~=0));
    rstl.svm_rstl.time = toc;
    rstl.svm_labs = reshape(full_labs_svm, M, N);
    
else
    Fori          = params{1};
    Fori          = reshape(Fori,M*N,L);
    tic;          % start time counting
    [trn_indx,~] = data_training(data_lbls,trng,true); %test_indx
    trn_indx = trn_indx(:,1);
    tmp1          = normc(Fori')';
    tmp2          = normc(Fori(trn_indx,:)')';
    t             = templateSVM('Standardize',1,'BoxConstraint',3);
    Md1           = fitcecoc(tmp2,data_lbls(trn_indx),'Learners',t);
    est_labs      = predict(Md1,tmp1);
    rstl.svm_rstl      = evaluate_results(est_labs(data_lbls~=0),...
        data_lbls(data_lbls~=0));
    rstl.svm_rstl.time = toc;
    rstl.svm_labs = reshape(est_labs,M,N);
end

end