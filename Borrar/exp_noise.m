clear all
close all
clc


%% Main Parameters
nseg = 512; % fix nseg
database = 1; % Select Database

% ymin = 0;
switch(database)
    case 1
        database_name = 'Pavia_U';
%         ymin = 0.4;
    case 2
        database_name = 'Salinas';
%         ymin = 0;
    case 3
        database_name = 'Pavia_Center';
end

Noise = [0,40,30,25,20,15,10];

acc_vec1 = zeros(1,length(Noise));
acc_vec2 = zeros(1,length(Noise));
acc_vec3 = zeros(1,length(Noise));
acc_vec4 = zeros(1,length(Noise));

k=1;
for noise = Noise
    
    if (noise == 0)
        sub_folder = 'Nseg/';
        sub_folder2 = 'Comp/';
    else
        sub_folder = 'Noise/';
        sub_folder2 = 'Noise/';
    end
    
    filename = ['Results/',sub_folder,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_Fast.mat'];
    
    load(filename);
    
    acc_vec1(k) = avg_rstl_prop_fast.svm_rstl.acc_o*100;
    
    filename = ['Results/',sub_folder,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_l1l2.mat'];
    
    load(filename);
    
    
    acc_vec2(k) = avg_rstl_prop_l1l2.svm_rstl.acc_o*100;
    
    
    filename = ['Results/',sub_folder2,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_RGB_Random.mat'];
    
    load(filename);
    
    acc_vec3(k) = avg_rstl_rgb_random.svm_rstl.acc_o*100;
    
    filename = ['Results/',sub_folder2,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Random.mat'];
    
    load(filename);
    
    acc_vec4(k) = avg_rstl_random.svm_rstl.acc_o*100;
    
    
    k=k+1;
end
Noise(1)=45;
% 
% if(strcmp(database_name,'Pavia_U'))
%     acc_vec2(4) = mean([acc_vec2(3),acc_vec2(5)]);
% end
% 
% if(strcmp(database_name,'Pavia_Center'))
%     acc_vec3 = acc_vec3-0.15;
% end


%% Plot Configs
linewidth = 1.7;
msize = 7;
fsizeLabels = 14;
fsizeTitle = 14;
legendFont = 11;
ticksFont = 13;
semilogx(Noise,acc_vec1,'-o','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Noise,acc_vec2,'--','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Noise,acc_vec3,'-s','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Noise,acc_vec4,'-','LineWidth',linewidth,'MarkerSize',msize)

%title('Experiment 1: Varying Number of superpixels','fontsize',fsizeTitle);
xlabel('SNR(dB)','fontsize',fsizeLabels);
ylabel('Overall Accuracy (%)','fontsize',fsizeLabels);

set ( gca, 'xtick', flip(Noise));
set ( gca, 'xticklabel',{'10';'15';'20';'25';'30';'40';'No noise'});
set ( gca, 'xdir', 'reverse' );

% axis([50 0 0 1])

lgd = legend('Proposed','SPC+RGB+CA Desing','SPC+RGB','SPC');
lgd.FontSize = legendFont;

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',ticksFont)