clear, clf, clc
N=200000; %采样点数
level=30; %直方图等级
K_dB=[-40 15];
Rician_ch=zeros(2,N);
color = ['r','b','g'];
% Rayleigh model
Rayleigh_ch=Ray_model(N); 
histogram(abs(Rayleigh_ch(:)),level,'FaceColor','r');%绘制直方图的函数 
hold on
% Rician model
for i=1:length(K_dB)
    Rician_ch(i,:)=Ric_model(K_dB(i),N);
    histogram(abs(Rician_ch(i,:)),level,'FaceColor',color(i+1));   
end
xlabel('x'), ylabel('Occurance')
legend('Rayleigh','Rician, K=-40dB','Rician, K=15dB')