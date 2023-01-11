function RMSE = get_RMSE(image1,image2)
       [~,~,d] =  size(image1);
       if d == 1
           dif = double(image1 - image2).^2;
           mse = mean(mean(dif));
           RMSE = sqrt(mse);
       end
       if  d == 3
           image3 = rgb2ycbcr(image1);
           image4 = rgb2ycbcr(image2);
           dif = double(image3(:,:,1) - image4(:,:,1)).^2;
           mse = mean(mean(dif));
           RMSE = sqrt(mse);
       end
end