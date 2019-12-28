clear all
close all
clc

addpath('Results/Tables/latex2table');

noise = 0; % fix noise
database = 5; % Select Database
nseg = 512;

switch(database)
    case 1
        database_name = 'Pavia_U';
        % Set row labels (use empty string for no label):
        input.tableRowLabels = {'Asphalt','Meadows','Gravel','Trees',...
            'Metal sheets', 'Bare soil', 'Bitumen', 'Bricks', 'Shadows',...
            'AA','OA','Kappa','SLIC Time','Sensing Time',...
            'Reconstruction Time', 'Classification Time','Total Time'};
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
    case 2
        database_name = 'Salinas';
        input.tableRowLabels = {'Broccoli-green-1','Broccoli-green-2',...
            'Fallow','Fallow-rough-plow','Fallow-smooth','Stubble',...
            'Celery', 'Grapes-untrained', 'Soil-vineyard-develop',...
            'Corn-senesced-green-weeds','Lettuce-romaine-4wk',...
            'Lettuce-romaine-5wk','Lettuce-romaine-6wk',...,
            'Lettuce-romaine-7wk','Vineyard-untrained',...
            'Vineyard-vertical-trellis','AA','OA','Kappa','SLIC Time','Sensing Time',...
            'Reconstruction Time', 'Classification Time','Total Time'};
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
    case 3
        database_name = 'Pavia_Center';
        input.tableRowLabels = {'Water','Trees','Meadows','Bricks',...
            'Bare soil', 'Asphalt', 'Bitumen', 'Tile', 'Shadows',...
            'AA','OA','Kappa','SLIC Time','Sensing Time',...
            'Reconstruction Time', 'Classification Time','Total Time'};
        
        sub_path1 = 'Nseg/';
        sub_path2 = 'Comp/';
        
    case 4
        database_name = 'Cacao_Mix1';
        input.tableRowLabels = {'Low Fermentation','Correct Fermentation',...
            'High Fermentation','AA','OA','Kappa','SLIC Time',...
            'Sensing Time','Reconstruction Time',...
            'Classification Time','Total Time'};
        
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        
    case 5
        database_name = 'Cacao_Mix2';
        input.tableRowLabels = {'Low Fermentation','Correct Fermentation',...
            'High Fermentation','AA','OA','Kappa','SLIC Time',...
            'Sensing Time','Reconstruction Time',...
            'Classification Time','Total Time'};
        
        sub_path1 = 'Cacao/';
        sub_path2 = 'Cacao/';
        
end


filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_Prop_Fast.mat'];

load(filename);

filename = ['Results/',sub_path1,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_Prop_l1l2.mat'];

load(filename);

filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_RGB_Random.mat'];

load(filename);

filename = ['Results/',sub_path2,database_name,'_nseg=',num2str(nseg),'_noise=',...
    num2str(noise),'_Random.mat'];

load(filename);

%=
random = avg_rstl_random.svm_rstl;
random.sensing_t = avg_rstl_random.time_sensing;
random.recon_t = avg_rstl_random.time_recon;
random.total_t = random.sensing_t + random.recon_t + random.time;
random.acc = random.acc.*100;   
random.acc_a = random.acc_a.*100;
random.acc_o = random.acc_o.*100;
random.kappa = random.kappa.*100;

%=
rgb_random = avg_rstl_rgb_random.svm_rstl;
rgb_random.sensing_t = avg_rstl_rgb_random.time_sensing;
rgb_random.recon_t = avg_rstl_rgb_random.time_recon;
rgb_random.total_t = rgb_random.sensing_t + rgb_random.recon_t + rgb_random.time;
rgb_random.acc = rgb_random.acc.*100;
rgb_random.acc_a = rgb_random.acc_a.*100;
rgb_random.acc_o = rgb_random.acc_o.*100;
rgb_random.kappa = rgb_random.kappa.*100;

%=
prop_l1l2 = avg_rstl_prop_l1l2.svm_rstl;
prop_l1l2.slic_t = avg_rstl_prop_l1l2.time_sp_extract;
prop_l1l2.sensing_t = avg_rstl_prop_l1l2.time_sensing;
prop_l1l2.recon_t = avg_rstl_prop_l1l2.time_recon;
prop_l1l2.total_t = prop_l1l2.sensing_t + prop_l1l2.recon_t +...
    prop_l1l2.time + prop_l1l2.slic_t;

prop_l1l2.acc = prop_l1l2.acc.*100;
prop_l1l2.acc_a = prop_l1l2.acc_a.*100;
prop_l1l2.acc_o = prop_l1l2.acc_o.*100;
prop_l1l2.kappa = prop_l1l2.kappa.*100;

%=
prop = avg_rstl_prop_fast.svm_rstl;

prop.slic_t = avg_rstl_prop_fast.time_sp_extract;
prop.sensing_t = avg_rstl_prop_fast.time_sensing;
prop.recon_t = avg_rstl_prop_fast.time_recon;
prop.total_t = prop.sensing_t + prop.recon_t +...
    prop.time + prop.slic_t;

prop.acc = prop.acc.*100;
prop.acc_a = prop.acc_a.*100;
prop.acc_o = prop.acc_o.*100;
prop.kappa = prop.kappa.*100;

% numeric values you want to tabulate:
% this field has to be an array or a MATLAB table
% in this example we use an array
input.data = ...
[random.acc,rgb_random.acc,prop_l1l2.acc,prop.acc;...
 random.acc_a,rgb_random.acc_a,prop_l1l2.acc_a,prop.acc_a;...
 random.acc_o,rgb_random.acc_o,prop_l1l2.acc_o,prop.acc_o;...
 random.kappa,rgb_random.kappa,prop_l1l2.kappa, prop.kappa;...
 NaN,NaN,prop_l1l2.slic_t, prop.slic_t;...
 random.sensing_t,rgb_random.sensing_t,prop_l1l2.sensing_t,prop.sensing_t;...
 random.recon_t,rgb_random.recon_t,prop_l1l2.recon_t,prop.recon_t;...
 random.time,rgb_random.time,prop_l1l2.time, prop.time;...
 random.total_t,rgb_random.total_t,prop_l1l2.total_t,prop.total_t];

% Optional fields:

% Set column labels (use empty string for no label):
input.tableColLabels = {'Random','SPC+RGB','SPC+RGB+CA Desing',...
    'Proposed'};


% Switch transposing/pivoting your table:
input.transposeTable = 0;

% Determine whether input.dataFormat is applied column or row based:
input.dataFormatMode = 'column'; % use 'column' or 'row'. if not set 'colum' is used

% Formatting-string to set the precision of the table values:
% For using different formats in different rows use a cell array like
% {myFormatString1,numberOfValues1,myFormatString2,numberOfValues2, ... }
% where myFormatString_ are formatting-strings and numberOfValues_ are the
% number of table columns or rows that the preceding formatting-string applies.
% Please make sure the sum of numberOfValues_ matches the number of columns or
% rows in input.tableData!
%
%input.dataFormat = {'%.3f',2,'%.1f',1}; % three digits precision for first two columns, one digit for the last
input.dataFormat = {'%.2f',4};

% Define how NaN values in input.tableData should be printed in the LaTex table:
input.dataNanString = '-';

% Column alignment in Latex table ('l'=left-justified, 'c'=centered,'r'=right-justified):
input.tableColumnAlignment = 'c';

% Switch table borders on/off (borders are enabled by default):
input.tableBorders = 1;

% Uses booktabs basic formating rules ('1' = using booktabs, '0' = not using booktabs).
% Note that this option requires the booktabs package being available in your LaTex.
% Also, setting the booktabs option to '1' overwrites input.tableBorders if it exists.
% input.booktabs = 0;


% LaTex table caption:
input.tableCaption = 'MyTableCaption';

% LaTex table label:
input.tableLabel = 'MyTableLabel';

% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 1;

% call latexTable:
latex = latexTable(input);