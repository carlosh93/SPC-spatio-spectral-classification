clear all
close all
clc

load('mix2_mod.mat');

A = reshape(hyperimg,[384*384,300]);
A = A';
plot(mean(A,2))


figure
rgbImage = cat(3,hyperimg(:,:,91),hyperimg(:,:,240)*0.8,hyperimg(:,:,272));
imshow(uint8(255*rgbImage./max(rgbImage(:))))