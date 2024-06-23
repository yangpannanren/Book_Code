%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子程序功能：扩展卡尔曼滤波算法
% 函数有bug。。。。。。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xout,Pout]=ukf_battery(X,Z,k,Q,R,P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UKF滤波, UT变换
L=4;  % 状态的维数
alpha=1;
kalpha=0;
belta=2;
ramda=3-L;
% 初始化权值,分配内存
Wm=zeros(1,2*L+1);
Wc=zeros(1,2*L+1);
for j=1:2*L+1
    Wm(j)=1/(2*(L+ramda));
    Wc(j)=1/(2*(L+ramda));
end
Wm(1)=ramda/(L+ramda);
Wc(1)=ramda/(L+ramda)+1-alpha^2+belta;   % 权值计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=eye(4);
G=1;  % 过程噪声驱动矩阵，本例为1
P0=P;
% Q  过程噪声
% R  测量噪声
%第一步：获得一组Sigma点集
cho=(chol(P*(L+ramda)))';    % 用到方差P
for j=1:L
    xgamaP1(:,j)=X+cho(:,j);
    xgamaP2(:,j)=X-cho(:,j);
end
Xsigma=[X,xgamaP1,xgamaP2]; % 得到Sigma点集
% 第二步：对Sigma点集进行一步预测
Xsigmapre=F*Xsigma;
%第三步：利用第二步的结果计算均值和协方差
Xpred=0;    % 均值
for j=1:2*L+1
    Xpred=Xpred+Wm(j)*Xsigmapre(:,j);
end
Ppred=0;    % 协方差阵预测
for j=1:2*L+1
    Ppred=Ppred+Wc(j)*(Xsigmapre(:,j)-Xpred)*(Xsigmapre(:,j)-Xpred)';
end
Ppred=Ppred+Q;
% 第四步：根据预测值，再一次使用UT变换，得到新的sigma点集
chor=(chol(Ppred*(L+ramda)))';
XaugsigmaP1=zeros(L,L);
XaugsigmaP2=zeros(L,L);
for j=1:L
    XaugsigmaP1(:,j)=Xpred+chor(:,j);
    XaugsigmaP2(:,j)=Xpred-chor(:,j);
end
Xaugsigma=[Xpred XaugsigmaP1 XaugsigmaP2];
% 第五步：观测预测
Zsigmapre=zeros(1,2*L+1);
for j=1:2*L+1    %  观测预测
    Zsigmapre(1,j)=hfun(Xaugsigma(:,j),k);
end
% 第六步：计算观测预测均值和协方差
Zpred=0;         %  观测预测的均值
for j=1:2*L+1
    Zpred=Zpred+Wm(j)*Zsigmapre(1,j);
end
Pzz=0;
for j=1:2*L+1
    Pzz=Pzz+Wc(j)*(Zsigmapre(1,j)-Zpred)*(Zsigmapre(1,j)-Zpred)';
end
Pzz=Pzz+R;  % 得到协方差Pzz
Pxz=0;
for j=1:2*L+1
    Pxz=Pxz+Wc(j)*(Xaugsigma(:,j)-Xpred)*(Zsigmapre(1,j)-Zpred)';
end
% 第七步：计算kalman增益
Kg=Pxz*inv(Pzz);                   % Kalman增益
%第八步：状态和方差更新
Xout=Xpred+Kg*(Z-Zpred);           % 状态更新
Pout=Ppred-Kg*Pzz*Kg';                 % 方差更新
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%