load WestAfricanEbolaOutbreak2014
plot(WHOreportdate, [TotalCasesGuinea TotalCasesLiberia TotalCasesSierraLeone],'.-')
legend('几内亚','利比里亚','塞拉利昂');
title('埃博拉病毒疾病疑似病例、疑似病例和确诊病例总数');

daysSinceOutbreak = datetime(2014, 3, 24+(0:400));
cases = interp1(WHOreportdate, TotalCasesLiberia, daysSinceOutbreak);
dayOverDayCases = diff(cases);

plot(dayOverDayCases)
title('自2014年3月25日以来利比里亚的新病例率(每日)');
ylabel('每日报告病例数的变化');
xlabel('自爆发以来的天数');

cusum(dayOverDayCases(1:101))
legend('上和','下和')
climit = 5;
mshift = 1;
tmean = 0;
tdev = 3;
cusum(dayOverDayCases(1:100),climit,mshift,tmean,tdev)


load nilometer
years = 622:1284;
plot(years,nileriverminima)
title('尼罗河年最低水位')
xlabel('年')
ylabel('水位(m)')

i = findchangepts(diff(nileriverminima),'Statistic','rms');

ax = gca;
xp = [years(i) ax.XLim([2 2]) years(i)];
yp = ax.YLim([1 1 2 2]);
patch(datenum(xp),yp,[.5 .5 .5],'facealpha',0.1);