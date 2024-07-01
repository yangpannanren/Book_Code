%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：产生符合伽马分布的噪声，并画图显示
% Fig.3-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function genGamaNoise
afa=3; %形状参数
beita=2; %尺度参数
N=50; %数据长度
w1=zeros(1,N); %伽马分布的噪声初始化
w2=w1; %伽马分布的噪声初始化
w1=gamrnd(afa,beita,1,N); %方法一:一次性产生所有的噪声
for k=1:N
    w2(k)=gamrnd(afa,beita); %方法二:一次产生一个数
end
figure %画图显示
hold on;box on;
plot(w1,'-ko','MarkerFaceColor','r'); %设置不同线型，数据点颜色
plot(w2,'-k^','MarkerFaceColor','g'); %设置不同线型，数据点颜色
xlabel('time');ylabel('Noise');
legend('一次性产生','一次产生一个数');
title('伽马分布的噪声图');