function [train_SL, test_SL] = data_training(varargin)

if nargin < 2 
    error('Insuficient number of inputs');
end

if nargin >= 2
    data_lbls = varargin{1};
    num = varargin{2};
end

if nargin > 2
    percFlag = varargin{3};
else
    percFlag = true;
end

[no_rows,no_lines] = size(data_lbls);
no_classes = length(unique(data_lbls(:)))-1;

if percFlag
    for ii = 1: no_classes
        RandSampled_Num(ii) = round((num/100)*length(find(data_lbls(:)==ii)));
    end
end

%% Select the number of training samples for each class
%RandSampled_Num = [5 143 83 24 48 73 3 48 2 97 246 59 21 127 39 9]; 

Nonzero_map = zeros(no_rows,no_lines);
Nonzero_index =  find(data_lbls ~= 0);
Nonzero_map(Nonzero_index)=1;


%% Create the experimental set based on groundtruth of HSI
Train_Label = [];
Train_index = [];
for ii = 1: no_classes
   index_ii =  find(data_lbls == ii);
   class_ii = ones(length(index_ii),1)* ii;
   Train_Label = [Train_Label class_ii'];
   Train_index = [Train_index index_ii'];   
end
trainall = zeros(2,length(Train_index));
trainall(1,:) = Train_index;
trainall(2,:) = Train_Label;

%% Create the Training set with randomly sampling 3-D Dataset and its correponding index
indexes =[];
for i = 1: no_classes
  W_Class_Index = find(Train_Label == i);
  Random_num = randperm(length(W_Class_Index));
  Random_Index = W_Class_Index(Random_num);
  Tr_Index = Random_Index(1:RandSampled_Num(i));
  indexes = [indexes Tr_Index];
end   
indexes = indexes';
train_SL = trainall(:,indexes);
%train_samples = img1(:,train_SL(1,:))';
train_labels= train_SL(2,:)';

%% Create the Testing set with randomly sampling 3-D Dataset and its correponding index
test_SL = trainall;
test_SL(:,indexes) = [];
%test_samples = img1(:,test_SL(1,:))';
test_labels = test_SL(2,:)';


train_SL = train_SL';
test_SL = test_SL';
end