clear all
close all
clc

%% Add to PATH
addpath('../../RGB Superpixels Fusion/Data Classification/');

nseg = 512; % fix nseg
noise = 0; % fix noise

database = 1; % Select Database

% ymin = 0;
switch(database)
    case 1
        load('PaviaU.mat')
        load('PaviaU_gt.mat')
        filename = 'Pavia_U';
        hyperimg = paviaU(:,:,1:102);
        data_lbls = paviaU_gt; % Groundtruth
        data_lbls = data_lbls(:);
        clear paviaU paviaU_gt;
        %         ymin = 0.4;
    case 2
        load('Salinas_corrected.mat');
        load('Salinas_gt.mat');
        filename = 'Salinas';
        hyperimg = salinas_corrected(:,1:216,:);
        data_lbls = salinas_gt(:,1:216); % Groundtruth
        data_lbls = data_lbls(:);
        clear   salinas_corrected salinas_gt
        %         ymin = 0;
    case 3
        load('Pavia_centre.mat')
        load('Pavia_centre_gt.mat')
        filename = 'Pavia_Center';
        hyperimg = pavia(:,1:712,:);
        data_lbls = pavia_gt(:,1:712);
        [M,N,~] = size(hyperimg);
        hyperimg = imresize3(hyperimg,[M/2,N/2,102],'box');
        data_lbls = imresize(data_lbls,[M/2,N/2],'nearest');
        data_lbls = data_lbls(:);
        clear pavia pavia_gt M N L
end


reconstruct_flag = true; % the scene should be reconstructed
L2 = 3; % bands RGB image
Trng = [1 3 5 7 10];  %numero de muestras de entrenamiento en % por clase
nExp = 1;
for trng = Trng
    
    % Defining Results Matrices
    rstl_prop_fast = {};
    rstl_prop_l1l2 = {};
    rstl_rgb_random = {};
    rstl_random = {};
    
    [M,N,L]=size(hyperimg);
    
    %% Building RGB Image
    DRGB=kron(speye(L2),sparse(kron(ones(1,L/L2),speye(M*N))));   % RGB Sampling
    DRGBT=DRGB';
    Frgb=DRGB*hyperimg(:); %Side information
    
    %% Superpixels Extraction
    tic
    [D,Da,F]=D_SLIC(reshape(Frgb,M,N,L2),M,N,L2,nseg);
    time_sp_extract = toc;
    
    % Proposed Designed Sensing Matrix
    H=hadamard(F);
    HR=H*D; % Real sensing Matrix
    
    %compression ratio
    comp = length(find(HR>0))/(F*M*N);
    
    % Random Sensing Matrix
    
    H_random = 2*double(rand(F,M*N)<comp)-1;
    
    %% Single Pixel Sensing
    
    %SPC Sensing with Designed CA
    tic
    g=[];
    for i=1:L
        aux=hyperimg(:,:,i);
        g=[g; HR*aux(:)];
    end
    time_prop_sensing = toc; %sensing time
    
    
    %% Single Pixel Proposed Fast Reconstruction
    
    % Reconstruction
    if(reconstruct_flag)
        tic
        FIR=[]; % Feature matrix with superpixel information
        for i=1:L
            fmr=(1/F)*H'*g(1+(i-1)*F:F*i);
            FIR=cat(2,FIR,fmr);
            ResultP(:,:,i)=reshape(Da'*fmr,M,N);
        end
        time_prop_fast_recon=toc;
        psnr_prop_fast=fun_PSNR(hyperimg,ResultP);
    else
        FIR = reshape(g,[F,L]);
    end
    
    % Supervised Classification
    [rstl_prop_fast] = supervised_classification(data_lbls,trng,...
        M,N,L,1,{D;Da;FIR});
    %save times
    rstl_prop_fast.time_sp_extract = time_sp_extract;
    rstl_prop_fast.time_sensing = time_prop_sensing;
    if reconstruct_flag
        rstl_prop_fast.time_recon = time_prop_fast_recon;
    end
    %save psnr
    if reconstruct_flag
        rstl_prop_fast.recon_psnr = psnr_prop_fast;
    end
    
    %% Single Pixel Proposed l1-l2 Reconstruction
    
    save_recon_filename = ['Reconstruction_CA_Designed_l1l2',filename,...
        '_Nseg=',num2str(nseg),'_Noise=',num2str(noise),...
        '_exp_num=',num2str(nExp),'.mat'];
    
    % Load Reconstruction
    load(['Results/Reconstructions/',save_recon_filename,'.mat']);
    
    % Supervised Classification
    [rstl_prop_l1l2] = supervised_classification(data_lbls,trng,...
        M,N,L,2,{result_recon});
    %save times
    rstl_prop_l1l2.time_sp_extract = time_sp_extract;
    rstl_prop_l1l2.time_sensing = time_prop_sensing;
    rstl_prop_l1l2.time_recon = t_recon;
    %save psnr
    rstl_prop_l1l2.recon_psnr = psnr_recon;
    
    %===
    
    %% Single Pixel RGB + Random Coded Aperture
    
    y = [g_random; Frgb];
    save_recon_filename = ['Reconstruction_RGB_Random',filename,...
        '_Nseg=',num2str(nseg),'_Noise=',num2str(noise),...
        '_exp_num=',num2str(nExp),'.mat'];
    
    Reconstruction
    [result_recon_rgb_random,psnr_rgb_random,t_recon_rgb_random] = ...
        reconstruction(hyperimg,DRGB,F,tau,H_random,y,iter,true,...
        save_recon_filename);
    
    Supervised Classification
    [rstl_rgb_random] = supervised_classification(data_lbls,trng,...
        M,N,L,3,{result_recon_rgb_random});
    save times
    rstl_rgb_random.time_sensing = time_random_sensing;
    rstl_rgb_random.time_recon = t_recon_rgb_random;
    save psnr
    rstl_rgb_random.recon_psnr = psnr_rgb_random;
    
    
    %% Single Pixel only Random Coded Aperture
    y = [g_random];
    save_recon_filename = ['Reconstruction_Random',filename,...
        '_Nseg=',num2str(nseg),'_Noise=',num2str(noise),...
        '_exp_num=',num2str(nExp),'.mat'];
    
    Reconstruction
    [result_recon_random,psnr_random,t_recon_random] = ...
        reconstruction(hyperimg,[],F,tau,H_random,y,iter,true,...
        save_recon_filename);
    
    Supervised Classification
    [rstl_random] = supervised_classification(data_lbls,trng,...
        M,N,L,4,{result_recon_random});
    save times
    rstl_random.time_sensing = time_random_sensing;
    rstl_random.time_recon = t_recon_random;
    save psnr
    rstl_random.recon_psnr = psnr_random;
    
end