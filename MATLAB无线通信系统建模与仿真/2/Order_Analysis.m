load helidata
vib = vib - mean(vib);  % 拆卸直流组件
subplot(2,1,1) 
plot(t,rpm)             % 绘制发动机转速
xlabel('时间(s)') 
ylabel('发动机转速(RPM)')
title('发动机转速')

subplot(2,1,2) 
plot(t,vib)             % 绘制振动信号 
xlabel('时间(s)') 
ylabel('电压(mV)')
title('振动加速度数据')

rpmfreqmap(vib,fs,rpm)

rpmfreqmap(vib,fs,rpm,1)

rpmordermap(vib,fs,rpm,0.005)

[map,mapOrder,mapRPM,mapTime] = rpmordermap(vib,fs,rpm,0.005);

figure
orderspectrum(map,mapOrder)
[spec,specOrder] = orderspectrum(map,mapOrder);          
[~,peakOrders] = findpeaks(spec,specOrder,'SortStr','descend','NPeaks',2);
peakOrders = round(peakOrders,3)

ordertrack(map,mapOrder,mapRPM,mapTime,peakOrders)

orderWaveforms = orderwaveform(vib,fs,rpm,peakOrders);
helperPlotOrderWaveforms(t,orderWaveforms,vib)

mainRotorOrder = mainRotorEngineRatio; 
tailRotorOrder = tailRotorEngineRatio;

ratioMain = peakOrders/mainRotorOrder

ratioTail = peakOrders/tailRotorOrder

load helidataAfter
vib = vib - mean(vib);             % 拆卸直流组件
[mapAfter,mapOrderAfter] = rpmordermap(vib,fs,rpm,0.005);
figure
hold on  
orderspectrum(map,mapOrder)
orderspectrum(mapAfter,mapOrderAfter)
legend('调整之前','调整之后')