clear all
close all
clc

%% Add to PATH
addpath('../../RGB Superpixels Fusion/Data Classification/');
addpath('Cacao_Data/');
nseg = 512;

noise = 0; % fix noise

database = 5; % Select Database
off_prop = 0;
off_l1l2 = 0;
off_rand = 0;
off_rgbr = 0;
off_gt = 0;
switch(database)
    case 1
        database_name = 'Pavia_U';
        load('PaviaU_color.mat');
        load('PaviaU.mat')
        load('PaviaU_gt.mat')
        hyperimg = paviaU(:,:,1:102);
        data_lbls = paviaU_gt; % Groundtruth
        clear paviaU paviaU_gt;
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
        gcf_position = [1000, 1000, 400, 550];
        
    case 2
        database_name = 'Salinas';
        load('Salinas_corrected.mat');
        load('Salinas_gt.mat');
        load('Salinas_color.mat');
        hyperimg = salinas_corrected(:,1:216,:);
        data_lbls = salinas_gt(:,1:216); % Groundtruth
        clear   salinas_corrected salinas_gt
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
        gcf_position = [1000, 1000, 400, 550];
        
    case 3
        database_name = 'Pavia_Center';
        load('Pavia_color.mat');
        load('Pavia_centre.mat')
        load('Pavia_centre_gt.mat')
        hyperimg = pavia(:,1:712,:);
        data_lbls = pavia_gt(:,1:712);
        data_lbls_ori = data_lbls;
        [M,N,~] = size(hyperimg);
        hyperimg = imresize3(hyperimg,[M/2,N/2,102],'box');
        data_lbls = imresize(data_lbls,[M/2,N/2],'nearest');
        
        clear pavia pavia_gt M N L
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
        gcf_position = [1000, 1000, 400, 550];
        
    case 4
        database_name = 'Cacao_Mix1';
        load('mix1_mod_gt.mat')
        data_lbls = mix1_gt;
        clear mix1_gt
        
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        
        gcf_position = [1000, 1000, 384, 384];
        
        off_prop = 0;
        off_l1l2 = 1;
        off_rand = 1;
        off_rgbr = 1;
        off_gt = 1;
        
    case 5
        database_name = 'Cacao_Mix2';
        load('mix2_mod_gt.mat')
        data_lbls = mix2_gt;
        clear mix2_gt
        
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        
        gcf_position = [1000, 1000, 384, 384];
        
        off_prop = 0;
        off_l1l2 = 1;
        off_rand = 1;
        off_rgbr = 1;
        off_gt = 1;
end

filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_Prop_Fast.mat'];

load(filename);


if(strcmp(database_name,'Pavia_U'))
    nseg = 128;
    filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_l1l2.mat'];
    
    load(filename);
    nseg = 512;
else
    
    filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
        num2str(noise),'_Prop_l1l2.mat'];
    
    load(filename);
end


filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_RGB_Random.mat'];

load(filename);

filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_Random.mat'];

load(filename);

if(strcmp(database_name,'Salinas'))
    
    figure
    avg_rstl_prop_fast.svm_labs(data_lbls==0)=17;
    image(avg_rstl_prop_fast.svm_labs-1); colormap(cmp);
    title(['Proposed OA: ',num2str(avg_rstl_prop_fast.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Prop_Fast',database_name);
    
    figure
    avg_rstl_prop_l1l2.svm_labs(data_lbls==0)=17;
    image(avg_rstl_prop_l1l2.svm_labs); colormap(cmp);
    title(['SPC+RGB+CA Desing OA: ',num2str(avg_rstl_prop_l1l2.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Prop_l1l2',database_name);
    
    figure
    avg_rstl_rgb_random.svm_labs(data_lbls==0)=17;
    image(avg_rstl_rgb_random.svm_labs); colormap(cmp);
    title(['SPC+RGB OA: ',num2str(avg_rstl_rgb_random.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'RGB_Random',database_name);
    
    figure
    avg_rstl_random.svm_labs(data_lbls==0)=17;
    image(avg_rstl_random.svm_labs); colormap(cmp);
    title(['SPC OA: ',num2str(avg_rstl_random.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Random',database_name);
    
    data_lbls(data_lbls==0)=17;
    figure
    image(data_lbls); colormap(cmp);
    title('Groundtruth');
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Groundtruth',database_name);
else
    figure
    avg_rstl_prop_fast.svm_labs(data_lbls==0)=0;
    image(avg_rstl_prop_fast.svm_labs+off_prop); colormap(cmp);
    title(['Proposed OA: ',num2str(avg_rstl_prop_fast.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Prop_Fast',database_name);

    figure
    avg_rstl_prop_l1l2.svm_labs(data_lbls==0)=0;
    image(avg_rstl_prop_l1l2.svm_labs+off_l1l2); colormap(cmp);
    title(['SPC+RGB+CA Desing OA: ',num2str(avg_rstl_prop_l1l2.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Prop_l1l2',database_name);

    
    figure
    avg_rstl_rgb_random.svm_labs(data_lbls==0)=0;
    image(avg_rstl_rgb_random.svm_labs+off_rgbr); colormap(cmp);
    title(['SPC+RGB OA: ',num2str(avg_rstl_rgb_random.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'RGB_Random',database_name);

    
    figure
    avg_rstl_random.svm_labs(data_lbls==0)=0;
    image(avg_rstl_random.svm_labs+off_rand); colormap(cmp);
    title(['SPC OA: ',num2str(avg_rstl_random.svm_rstl.acc_o*100,4),'%']);
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Random',database_name);
    
    data_lbls(data_lbls==0)=0;
    figure
    image(data_lbls+off_gt); colormap(cmp);
    title('Groundtruth');
    set(gcf, 'Position',  gcf_position)
    axis off
    save_pdf(gca,gcf,'Groundtruth',database_name);

end


