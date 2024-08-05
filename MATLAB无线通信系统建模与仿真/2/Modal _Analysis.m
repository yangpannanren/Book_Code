load modaldata XhammerMISO1 YhammerMISO1 fs
rest = 1:1e4;
rval = 2e4:5e4;
Ts = 1/fs;
Estimation = iddata(YhammerMISO1(rest,:),XhammerMISO1(rest,:),Ts);
Validation = iddata(YhammerMISO1(rval,:),XhammerMISO1(rval,:),Ts,'Tstart',rval(1)*Ts);
%绘制估算数据和验证数据
plot(Estimation,Validation)
legend(gca,'show')
legend('估计','验证')
title('输入-输出数据');
xlabel('时间');ylabel('幅值');

Orders = 7;
opt = ssestOptions('Focus','simulation');
sys = ssest(Estimation,Orders,'Feedthrough',true,'Ts',Ts,opt);

compare(Validation,sys)
title('比较模拟反应')
xlabel('时间');ylabel('幅值');

Modes = 3;
[fn,dr,ms] = modalfit(sys,f,Modes)

[~,~,~,ofrf] = modalfit(sys,f,Modes);

clf
for ij = 1:3
    for ji = 1:3
        subplot(3,3,3*(ij-1)+ji)
        plot(f/1000,20*log10(abs(ofrf(:,ji,ij))))
        axis tight
        title(sprintf('输入%d -> 输出%d',ij,ji))
        if ij==3
            xlabel('频率(kHz)')
        end
    end
end