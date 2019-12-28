% res = 0.5; % want to reduce/enlarge 3D matrix to x times its original
% % size
% A = im;
function [A2] = resize3D(A1,res)
%     A1 = imresize(A,res); %resizes by 0.2 along the first 2 dimensions
    %we still have to take care of the third dimension:

    mrows = size(A1,2); %the second dimension is already the right size
    mcols = round(res*size(A1,3)); %we want to rescale the third dimension

    for i = 1:size(A1,1)
        B(:,:) = A1(i,:,:); %make a 2D array with the last two dimensions of A1
        B1 = imresize(B,[mrows,mcols]);
        A2(i,:,:) = B1;
    end
end