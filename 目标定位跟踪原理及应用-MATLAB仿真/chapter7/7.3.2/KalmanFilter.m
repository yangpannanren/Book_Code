%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：
% 单站多目标跟踪的建模程序，并用近邻法分类
% 主要模拟多目标的运动和观测过程，涉及融合算法---近邻法
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xpf,xparticle,Tpf]=PF(Z,S,canshu,xparticle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q=canshu.Q;R=canshu.R;F=canshu.F;G=canshu.G;N=canshu.N; % 粒子数
zPred=zeros(2,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Tpf=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
x0=S.x;
y0=S.y;
% 采样
for k=1:N
    xparticlePred(:,k)=F*xparticle(:,k)+5*G*sqrtm(Q)*G'*randn(4,1);
end
% 重要性权值计算
for k=1:N
    zPred(:,k)=feval('hfun',xparticlePred(:,k),x0,y0);
    z1=Z-zPred(:,k);
    Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99;%权值计算
end
% 归一化权重
Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
%重新采样
outIndex = randomR(1:N,Weight(1,:)');          % random resampling.
xparticle= xparticlePred(:,outIndex); % 获取新采样值
target=[mean(xparticle(1,:)),mean(xparticle(2,:)),...
    mean(xparticle(3,:)),mean(xparticle(4,:))]';
Xpf=target;
Tpf=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%