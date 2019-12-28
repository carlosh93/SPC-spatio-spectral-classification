%Prueba decimador

L=8;
L2=8;
M=128;
N=M;
clear hyperimg hyperimga hyperimgHR
load('video_espectral_128_128_8_8.mat')
namea=['VIdeo'];
hyperimg=X(:,:,:,1);
tau=[1e-6];
% for jjj=1:31
%     hyperimga(:,:,jjj)=resizem(hyperimgHR(:,:,jjj),0.25);
% end
% SL=floor(31/L);
% for Ll=1:L
%     hyperimg(:,:,Ll)=sum(hyperimga(:,:,SL*(Ll-1)+1:SL*Ll),3);
% end
% clear ya
c=1;
for SL=5:300:M*N*0.8
    clear ya
    [D,Da,F]=D_SLIC(reshape(hyperimg,N,N,L2),N,L2,SL);
    for i=1:L
        a=hyperimg(:,:,i);
        ya(:,i)=D*a(:);
    end
    for i=1:L
        a=hyperimg(:,:,i);
        hy1(:,i)=Da'*ya(:,i);
        hy2(:,i)=D'*ya(:,i);
    end
    PSNRh1(c)=fun_PSNR(hyperimg,reshape(hy1,M,M,L));
    PSNRh2(c)=fun_PSNR(hyperimg,reshape(hy2,M,M,L));
    c=c+1;
    SL
end