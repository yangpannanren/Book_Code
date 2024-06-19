%Hata模型
clear, clf, clc
fc=1.5e9;
htx=30;%发射天线高度
hrx=1;%发射天线高度
distance=[1:2:31].^2; %距离
y_urban=PL_Hata(fc,distance,htx,hrx,'urban');%市区
y_suburban=PL_Hata(fc,distance,htx,hrx,'suburban');%郊区
y_open=PL_Hata(fc,distance,htx,hrx,'open');%开阔地
semilogx(distance,y_urban,'b-s', distance,y_suburban,'r-o', distance,y_open,'k-^')
title(['Hata PL model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('urban','suburban','open area','Location','northwest')
grid on