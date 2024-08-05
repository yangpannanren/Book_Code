load('INR.mat')
plot(Date,INR,'o','DatetimeTickFormat','MM/dd/yy')
xlim([Date(1) Date(end)])
hold on
plot([xlim;xlim]',[2 3;2 3],'k:')
Date.Format = 'eeee, MM/dd/yy, HH:mm';
First = Date(1)

perweek = 1/7/86400;
[rum,tee] = resample(INR,Date,perweek,1,1,'spline');
plot(tee,rum,'.-','DatetimeTickFormat','MM/dd/yy')
title('INR')
xlim([Date(1) Date(end)])
hold off

nxt = datetime('10/30/2014 07:00 PM','Locale','en_US');

plot(Date,diff(datenum([Date;nxt]))/7,'o-', ...
    'DatetimeTickFormat','MM/dd/yy')

title('下一次测试时间')
xlim([Date(1) Date(end)])
ylabel('周')