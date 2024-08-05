load NIRSData;
figure
plot(tm,NIRSData(:,1))
hold on
plot(tm,NIRSData(:,2),'r-.')
legend('任务1','任务2','Location','NorthWest')
xlabel('秒')
title('NIRS数据')
grid on;hold off;

[wcoh,~,f,coi] = wcoherence(NIRSData(:,1),NIRSData(:,2),10,'numscales',16);
helperPlotCoherence(wcoh,tm,f,coi,'Seconds','Hz');
title('小波一致性');xlabel('秒');ylabel('Hz');

[wcoh,~,P,coi] = wcoherence(NIRSData(:,1),NIRSData(:,2),seconds(1/10),...
    'numscales',16);
helperPlotCoherence(wcoh,tm,seconds(P),seconds(coi),'Time (secs)','Periods (Seconds)');
title('小波一致性');xlabel('时间（s）');ylabel('周期（s）');