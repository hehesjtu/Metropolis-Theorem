%% Ablation study about \eta and \mu
lambda = [0 0.0002 0.0004 0.0006 0.0008 0.001 0.0012 0.0014 0.0016 0.0018];
rmse_lambda = [4.2392 4.2353 4.2331 4.2320 4.2309 4.2292 4.2310 4.2326 4.2334 4.2343];
plot(lambda,rmse_lambda,'rs-','lineWidth',2.5,'MarkerSize',6,'MarkerFaceColor','r');
set(gca,'XTickLabel',{'0';'0.0002';'0.0004';'0.0006';'0.0008';'0.001';'0.0012';'0.0014'...
    ;'0.0016';'0.0018';});

hold on;
rmse_mu = [4.2392 4.2387 4.2345 4.2333 4.2332 4.2327 4.2329 4.2358 4.2372 4.2379];
plot(lambda,rmse_mu,'bo-','lineWidth',2.5,'MarkerSize',6,'MarkerFaceColor','b');
set(gca,'XTickLabel',{'0';'0.0002';'0.0004';'0.0006';'0.0008';'0.001';'0.0012';'0.0014'...
    ;'0.0016';'0.0018';});
grid on;
xlabel('\eta and \mu');
ylabel('Root Mean Square Error (RMSE)');
title('Ablation studies of energy equation parameters');
legend('\eta','\mu');
