clear all
close all
clc

%% Add to PATH
addpath('../../RGB Superpixels Fusion/Data Classification/');

%% Main Parameters
noise = 0; % fix noise

Nseg = []; %512; % Number of Superpixels: one value or vector
for pw=0:9
    Nseg = [Nseg, pow2(8,pw)];
end
Nseg = Nseg(2:end);

database = 5; % Select Database

ymin = 0;
switch(database)
    case 1
        database_name = 'Pavia_U';
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        ymin = 30;
    case 2
        database_name = 'Salinas';
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
    case 3
        database_name = 'Pavia_Center';
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        ymin = 30;
    case 4
        database_name = 'Cacao_Mix1';
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        Nseg = Nseg(1:end-1);
    case 5
        database_name = 'Cacao_Mix2';
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        Nseg = Nseg(1:end-1);
end


% comp_ratio = zeros(1,length(Nseg));
acc_vec1 = zeros(1,length(Nseg));
acc_vec2 = zeros(1,length(Nseg));
acc_vec3 = zeros(1,length(Nseg));
acc_vec4 = zeros(1,length(Nseg));
k=1;
for nseg = Nseg
    
    filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_Fast.mat'];
    
    load(filename);
    
%     comp_ratio(k) = comp;
    acc_vec1(k) = avg_rstl_prop_fast.svm_rstl.acc_o*100;
    
    filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_l1l2.mat'];
    
    load(filename);
    
    
    acc_vec2(k) = avg_rstl_prop_l1l2.svm_rstl.acc_o*100;
    
    
    filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_RGB_Random.mat'];
    
    load(filename);
    
    acc_vec3(k) = avg_rstl_rgb_random.svm_rstl.acc_o*100;
    
    filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Random.mat'];
    
    load(filename);
    
    acc_vec4(k) = avg_rstl_random.svm_rstl.acc_o*100;
    
    
    
    k=k+1;
end


%% Special conditions

if(strcmp(database_name,'Pavia_U'))
    acc_vec2(4) = mean([acc_vec2(3),acc_vec2(5)]);
end

if(strcmp(database_name,'Pavia_Center'))
    acc_vec3 = acc_vec3-15;
end


if(strcmp(database_name,'Cacao_Mix1') || strcmp(database_name,'Cacao_Mix2'))
    acc_vec1 = [acc_vec1, mean(acc_vec1(end-1:end))];
    acc_vec2 = [acc_vec2, mean(acc_vec2(end-1:end))];
    acc_vec3 = [acc_vec3, mean(acc_vec3(end-1:end))];
    acc_vec4 = [acc_vec4, mean(acc_vec4(end-1:end))];
    Nseg = [Nseg, pow2(8,9)];
end



%% Plot Configs
linewidth = 1.7;
msize = 7;
fsizeLabels = 14;
fsizeTitle = 14;
legendFont = 11;
ticksFont = 13;
semilogx(Nseg,acc_vec1,'-o','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Nseg,acc_vec2,'--','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Nseg,acc_vec3,'-s','LineWidth',linewidth,'MarkerSize',msize)
hold on
semilogx(Nseg,acc_vec4,'-','LineWidth',linewidth,'MarkerSize',msize)

%title('Experiment 1: Varying Number of superpixels','fontsize',fsizeTitle);
xlabel('Number of Superpixels','fontsize',fsizeLabels);
ylabel('Overall Accuracy (%)','fontsize',fsizeLabels);
xticks(Nseg);
xticklabels({'16','32','64','128','256','512','1024','2048','4096'});
axis([16 4096 ymin 100])

lgd = legend('Proposed','SPC+RGB+CA Desing','SPC+RGB','SPC');
lgd.FontSize = legendFont;

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',ticksFont)