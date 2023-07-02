%% Metropolis theorem and its applications on single image detail enhancement
%% Journal paper: Multimedia Tools and Applications
%% First author: He Jiang
%  Date: 2023-07-02
%  All images using format "*png" 

clear all;clc;close all;warning off;
Pathr = '.\data\';
Pathw = '.\results\';
Files = dir(strcat(Pathr,'*.png')); 
LengthFiles = length(Files);
global counter1 counter2;
global T0 gamma;
T0 = 300;   % initial temperature
gamma = 0.95; % cooling coefficient
counter1 = 0;  % patch matching counter
counter2 = 0;  % additional patch matching using MT counter
factor = 4;
for ii = 1:LengthFiles
    disp(strcat('Now is processing the image named:',Files(ii).name));
    tic
    image=double(imread(strcat(Pathr,Files(ii).name)));
    outimg1=image(:,:,1);
    outimg2=image(:,:,2);
    outimg3=image(:,:,3);
    %% using Metropolis theorem to get H1
    H1_outimg1=MT(outimg1);             
    H1_outimg2=MT(outimg2); 
    H1_outimg3=MT(outimg3);
    %% get details
    Details=zeros(size(image,1),size(image,2),3);
    Details(:,:,1)=imresize(H1_outimg1,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,2)=imresize(H1_outimg2,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,3)=imresize(H1_outimg3,[size(image,1),size(image,2)],'bilinear');
    %% add details to the original images
    outimg1=outimg1+Details(:,:,1)*factor;
    outimg2=outimg2+Details(:,:,2)*factor;
    outimg3=outimg3+Details(:,:,3)*factor;
    outimg(:,:,1)=outimg1;
    outimg(:,:,2)=outimg2;
    outimg(:,:,3)=outimg3;
    outimg = uint8(outimg);
    toc
    imwrite(outimg,strcat(Pathw, Files(ii).name(1:end-4),'_MT',num2str(factor),'.png'));
    clear outimg;
    disp('...........................');
end
