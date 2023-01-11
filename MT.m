function Residual = MT(image)
    global counter1 counter2;
    global T0 gamma;
    hfs_y1=20;
    I0 = image;
    loop_number = 20;
    L1=imresize(I0,1.25,'bilinear'); 
    L0=imresize(imresize(I0,1.25,'bilinear'),size(I0),'bilinear'); 
    % the high frequency (residual homogeneity) needed to be protected
    H0=I0-L0;  
    % padding the original image
    largeL0=L0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeL1=L1([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeH0=H0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    
    % gradient and texture of the padding the original image
    grad_largeL1 = grad(largeL1);   grad_largeL0 = grad(largeL0);
    texture_largeL1 = texture(largeL1);   texture_largeL0 = texture(largeL0);
    sumh0=zeros(size(largeL1));
    counth0=zeros(size(largeL1));
    [newh1 neww1]=size(L1);
    [newh1x neww1x]=size(image);
    coef=newh1x/newh1;
    
    % search only between L0 and L1
    for centerx=1:1:newh1
         for centery=1:1:neww1
                 p_L1=largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
                 p_grad_L1 = grad_largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
                 p_texture_L1 = texture_largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
                 newx=floor(centerx*coef);  
                 newy=floor(centery*coef);
            % initial the best solution
                 retrievex=newx;
                 retrievey=newy;     
                 best_fit = 1000;   
           if T0>0.01 || loop_number>1
           %    in-place matching
             for iterin1=0:1
                for iterin2=0:1
                    p_L0 = largeL0(hfs_y1+newx-1+iterin1:hfs_y1+newx+1+iterin1,hfs_y1+newy-1+iterin2:hfs_y1+newy+1+iterin2);
                    p_grad_L0 = grad_largeL0(hfs_y1+newx-1+iterin1:hfs_y1+newx+1+iterin1,hfs_y1+newy-1+iterin2:hfs_y1+newy+1+iterin2);
                    p_texture_L0 = texture_largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
                    fit_new = sum(sum(abs(p_L1-p_L0))) + 0.001* sum(sum(abs(p_grad_L1-p_grad_L0))) +...
                        0.001* sum(sum(abs(p_texture_L1-p_texture_L0)));
                    % If new state is better, accept the state
                    if fit_new < best_fit 
                        counter1 = counter1 + 1;
                        best_fit = fit_new;
                        retrievex=newx+iterin1;
                        retrievey=newy+iterin2;
                     % If the new state is worse than the best state,
                     % accept the new state as the best state with a certain probability
                    else if  (fit_new > best_fit && rand<exp(-abs(best_fit-fit_new)/T0))
                        counter2 = counter2 + 1;
                        best_fit = fit_new;
                        retrievex=newx+iterin1;
                        retrievey=newy+iterin2;
                    end
                    T0 = gamma*T0;
                end
                end
            end
            loop_number = loop_number-1;
           end
            q_p_H0=double(largeH0(hfs_y1+retrievex-2:hfs_y1+retrievex+2,hfs_y1+retrievey-2:hfs_y1+retrievey+2));
            sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+q_p_H0;
            counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+1;
        end
    end
    counth0(counth0<1)=1;
    averageh0=round(10*sumh0./counth0)/10; 
    Residual = averageh0(hfs_y1+1:end-hfs_y1,hfs_y1+1:end-hfs_y1);
end