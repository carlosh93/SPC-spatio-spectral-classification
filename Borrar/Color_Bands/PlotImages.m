clc, clear, close all;
addpath('datacubeplotter/');

load RecM_Photomask_SUM_K=6_tau=4e-05.mat; %File to color

resf= result;

clear gray;

bands = [450 456 470 481 495 509 524 539 559 579 602 633 667]; %Wavelengths of the spectral bands
% bands = [450 466 484 503 524 549 580 621]; %SSCSI
% bands = [457 477 502 534 576 632]; %Real measurements colored filters
% bands= [454 468 485 505 528 556 594 639];

x_twist_orig = resf; %Complete image
x_twist_orig = resf(73:132,159:225,:); %Take a zoom portion of the simulations

x_twist = flipdim(x_twist_orig,1);
%temp = shiftCube(x_twist);
%x_twist = temp(:,end-247:end,:);
x_twist = x_twist.*(x_twist>=0);
x_twist = x_twist/max(x_twist(:));


%dispCube(x_twist,65,bands);
gain = 120;
x_twist=gain.*x_twist;

for i=1:length(bands)
    cmM=(gray*kron(ones(3,1),spectrumRGB(bands(i))));
    cmM=cmM/max(max(cmM));
    figure('visible','on'), subimage2(squeeze(flipdim(x_twist(:,:,i),1)),colormap(cmM));
%         text(10, 20, ['\bf' num2str(bands(i)) ' nm'],'color', [0.9 0.9 0.9], 'Fontsize', 26)
%     text(5, 243, ['\bf' num2str(bands(i)) ' nm'],'color', [0.9 0.9 0.9], 'Fontsize', 24) % Wavelength complete image
    text(5, 230, ['\bf' num2str(bands(i)) ' nm'],'color', [0.9 0.9 0.9], 'Fontsize', 20) % Wavelength zoom image Old
%     text(160, 243, ['\bf' num2str(round(psnr(i)*100)/100) 'dB'],'color',[0.9 0.9 0.9], 'Fontsize', 24) % PSNR value zoom image
%text(35, 140, ['\bf' num2str(round(psnr(i)*100)/100) 'dB'],'color',[0.9 0.9 0.9], 'Fontsize', 20) % PSNR value zoom image Simulations

    axis off;
    %print('-depsc', strcat('Lego_RecCA_band=', num2str(i))); %Save image as eps

    %     print('-dpng', strcat('all', num2str(22)));
end
