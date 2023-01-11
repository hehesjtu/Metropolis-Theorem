%% Adopt CNN for deep image prior
close all; clear all; clc; warning off;

%% parameter setting 
ReadingPath = '.\data\';
WritingPath = '.\results\';
Files = dir(strcat(ReadingPath,'*.png')); 
LengthFiles = length(Files); 
up_scale = 2; factor = 2;
model = './23-1-7_ImageNet_DIP.mat'; 

for i = 1:LengthFiles
    tic 
    disp(strcat('Now is processing the image: ', Files(i).name));
    %% read the ground truth
    im = imread(strcat(ReadingPath,Files(i).name));
    [m, n, d] = size(im);
    m = floor(m/4)*4;  n = floor(n/4)*4;
    im = im(1:m,1:n,:);
    detail_enhance = zeros(m,n,d);
    im1 = im(:, :, 1);
    im2 = im(:, :, 2);
    im3 = im(:, :, 3);
    im_gnd1 = single(modcrop(im1, up_scale))/255;
    im_gnd2 = single(modcrop(im2, up_scale))/255;
    im_gnd3 = single(modcrop(im3, up_scale))/255;
    
    %% get the bicubic features
    im_b1 = imresize(imresize(im_gnd1, 1/up_scale, 'bicubic'), up_scale, 'bicubic');
    im_b2 = imresize(imresize(im_gnd2, 1/up_scale, 'bicubic'), up_scale, 'bicubic');
    im_b3 = imresize(imresize(im_gnd3, 1/up_scale, 'bicubic'), up_scale, 'bicubic');
    
    %% get the deep features using deep image prior
    im_dip1 = DIP(model, im_b1);
    im_dip2 = DIP(model, im_b2);
    im_dip3 = DIP(model, im_b3);
    
    %% get the details
    detail1 = im_dip1 - im_b1;
    detail2 = im_dip2 - im_b2;
    detail3 = im_dip3 - im_b3;
    
    %% detail enhancement
    detail_enhance1 = im_dip1 + detail1*factor;
    detail_enhance2 = im_dip2 + detail2*factor;
    detail_enhance3 = im_dip3 + detail3*factor;
    detail_enhance(:,:,1) = detail_enhance1;
    detail_enhance(:,:,2) = detail_enhance2;
    detail_enhance(:,:,3) = detail_enhance3;
    
    %% write the enhanced images
    detail_enhance = uint8(detail_enhance*255);
    imwrite(detail_enhance,strcat(WritingPath, Files(i).name(1:end-4),'_DIP2.png'));
    toc
    clear detail_enhance; clear im;  
end
    













