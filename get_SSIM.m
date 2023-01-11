function mssim = get_SSIM(image1, image2)
%% calculate the structure similarity value between two images
im1 = image1; im2 = image2;
[l1, w1,d1] = size(im1);
[l2, w2,d2] = size(im2);
if ((l1~=l2)||(w1~=w2)||(d1~=d2))
    disp('Wrong Input!!');
end
if d==3
    im1=rgb2ycbcr(im1);
    im2=rgb2ycbcr(im2);
    img1 = im1(:,:,1);
    img2 = im2(:,:,1);
end
window = fspecial('gaussian',11,1.5); %
K(1) = 0.01;              % default settings
K(2) = 0.03;              %
L = 255;
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
window = window/sum(sum(window));

mu1=filter2(window,img1,'valid');
mu2=filter2(window,img2,'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;

if (C1 > 0 && C2 > 0)
   ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
else
   numerator1 = 2*mu1_mu2 + C1;
   numerator2 = 2*sigma12 + C2;
   denominator1 = mu1_sq + mu2_sq + C1;
   denominator2 = sigma1_sq + sigma2_sq + C2;
   ssim_map = ones(size(mu1));
   index = (denominator1.*denominator2 > 0);
   ssim_map(index) = (numerator1(index).*numerator2(index))./(denominator1(index).*denominator2(index));
   index = (denominator1 ~= 0) & (denominator2 == 0);
   ssim_map(index) = numerator1(index)./denominator1(index);
end

mssim=mean2(ssim_map);
end

