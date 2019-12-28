function [avg_rstl] = accum_avg(filename,rstl_name,new_rstl,exp)

if exp > 1
    load(filename);
    switch rstl_name
        case 'Prop_Fast'
            actual_rstl = avg_rstl_prop_fast;
            
        case 'Prop_l1l2'
            actual_rstl = avg_rstl_prop_l1l2;
            
        case 'RGB_Random'
            actual_rstl = avg_rstl_rgb_random;
            
        case 'Random'
            actual_rstl = avg_rstl_random;
    end
    
    avg_rstl.svm_rstl.acc=((exp-1)*actual_rstl.svm_rstl.acc...
        +new_rstl.svm_rstl.acc)/exp;
    avg_rstl.svm_rstl.acc_o=((exp-1)*actual_rstl.svm_rstl.acc_o...
        +new_rstl.svm_rstl.acc_o)/exp;
    avg_rstl.svm_rstl.acc_a=((exp-1)*actual_rstl.svm_rstl.acc_a...
        +new_rstl.svm_rstl.acc_a)/exp;
    avg_rstl.svm_rstl.kappa=((exp-1)*actual_rstl.svm_rstl.kappa...
        +new_rstl.svm_rstl.kappa)/exp;
    avg_rstl.svm_rstl.time=((exp-1)*actual_rstl.svm_rstl.time...
        +new_rstl.svm_rstl.time)/exp;
    
    if ~strcmp(rstl_name,'Random') && ~strcmp(rstl_name,'RGB_Random')
        avg_rstl.time_sp_extract = ((exp-1)*actual_rstl.time_sp_extract...
            +new_rstl.time_sp_extract)/exp;
    end
    
    avg_rstl.time_recon = ((exp-1)*actual_rstl.time_recon...
        +new_rstl.time_recon)/exp;
    
    avg_rstl.time_sensing = ((exp-1)*actual_rstl.time_sensing...
        +new_rstl.time_sensing)/exp;
    
    avg_rstl.recon_psnr = ((exp-1)*actual_rstl.recon_psnr...
        +new_rstl.recon_psnr)/exp;
    
    if actual_rstl.svm_rstl.kappa > new_rstl.svm_rstl.kappa
        avg_rstl.svm_labs = new_rstl.svm_labs;
    end
    
    avg_rstl.it_exp = exp;
else
    avg_rstl = new_rstl;
    avg_rstl.it_exp = exp;
end