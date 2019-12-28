function [recon_results,psnr,time] = reconstruction(hyperimg,DRGB,F,tau,H,y,iter,s_flag,filename)
%F: Number of superpixels
tic
%% Add SParSa path
addpath('Support/');
addpath('Support/SpaRSA_2.0/');
[M,N,L] = size(hyperimg);

G = MakeONFilter('Symmlet',8);  % Wavelet transformation basis
media = 0;
B = myHyperspectral_shiftKronmulti(G,M,N,L,media,F,H); % Object
Bt = B';
Hp=@(x)HmrDirect(x,H,DRGB,M,N,L);
HpT=@(x)HmrTras(x,H',DRGB',F,L);
wt=ones(M,N,L)*1;
wt=wt(:);
lambda_max = norm(2*(HpT(y)),inf);
maxiter=iter;
lambda=tau*lambda_max*wt;
disp('Running Reconstruction Algorithm: SpaRSA');


[recon_results,~,~,~,~,~]= SpaRSA(y,Hp,lambda(1),'AT',HpT,'ToleranceA',1e-16,'MaxiterA',maxiter,'Verbose',1);
%[~,result,~,~,~,~,~]= GPSR_BB(y,Hp,lambda(1),'AT',HpT,'ToleranceA',1e-16,'MaxiterA',maxiter,'Verbose',0);
resultP=reshape(recon_results(:),M,N,L);
psnr=fun_PSNR(hyperimg,resultP);
time=toc;

if s_flag
    save(['Results/Reconstructions/',filename,'.mat'],'recon_results','psnr','time');
end
end