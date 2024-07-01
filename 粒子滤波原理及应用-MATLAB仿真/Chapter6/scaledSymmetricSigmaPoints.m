%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xPts, wPts, nPts] = scaledSymmetricSigmaPoints(x,P,alpha,beta,kappa)
% sigma 点集数目
n    = size(x(:),1);
nPts = 2*n+1;
% kappa参数重新计算
kappa = alpha^2*(n+kappa)-n;
% 申请空间，初始化
wPts=zeros(1,nPts);
xPts=zeros(n,nPts);
% 计算协方差矩阵的均方根
Psqrtm=(chol((n+kappa)*P))';
% 得到sigma points 的矩阵表示
xPts=[zeros(size(P,1),1) -Psqrtm Psqrtm];
% 加入均值到 xPts
xPts = xPts + repmat(x,1,nPts);
% 每个sigma 点的权值计算
wPts=[kappa 0.5*ones(1,nPts-1) 0]/(n+kappa);
% 计算第0个方差权重
wPts(nPts+1) = wPts(1) + (1-alpha^2) + beta;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%