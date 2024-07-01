%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：用于分析白噪声和有色噪声的频谱
% Fig.3-13、3-14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function white_noise_and_colored_noise_compare2
L=500; %仿真长度
c=[1 0.5 0.2]; %分子分母多项式系数
d=[1 -1.5 0.7 0.1];
Nc=length(c)-1;     %分子分母的阶次
Nd=length(d)-1 ;
XX=zeros(Nc,1); %白噪声初值，Xx和YY 都是为分子分母递推服务的
YY=zeros(Nd,1);
X=randn(L,1); %产生均值为0，方差为1的高斯白噪声序列
Y=zeros(1,L);
for k=1:L
    Y(k)=-d(2:Nd+1)*YY+c*[X(k);XX]; %产生有色噪声
    % 数据更新(因为递推，需要更新数据)
    for i=Nd:-1:2
        YY(i)=YY(i-1);
    end
    YY(1)=Y(k);
    for i=Nc:-1:2
        XX(i)=XX(i-1);
    end
    XX(1)=X(k);
end
% 计算频谱
% 白噪声的频谱
[Fx,f1] = myFFT(X',512);
Px = 1/L * Fx.*conj(Fx);
% 有色噪声的频谱
[Fy,f2] = myFFT(Y,512);
Py = 1/L * Fy.*conj(Fy);
% 画出噪声信号
figure
subplot(2,1,1);
plot(X);
xlabel('k');ylabel('噪声幅值');title('白噪声序列');
subplot(2,1,2);
plot(Y);
xlabel('k');ylabel('噪声幅值');title('有色噪声序列');
sgtitle('噪声幅值对比')
% 功率谱
figure
subplot(211)
plot(f1,Px)
xlabel('k');ylabel('白噪声频谱');title('白噪声序列');
subplot(212)
plot(f2,Py)
xlabel('k');ylabel('有色噪声频谱');title('有色噪声序列');
sgtitle('频谱对比')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%