%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman滤波算法程序，对目标位置跟踪,主要滤除跟踪过程的观测噪声
%  详细原理介绍及中文注释请参考：
%  《卡尔曼滤波原理及应用-MATLAB仿真》，电子工业出版社，黄小平著。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kalman
clear,clc
Imzero = zeros(240,320,3);
for i = 1:5
    Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
    Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
R=[[0.2845,0.0045]',[0.0045,0.0455]'];
H=[1 0 0 0;0 1 0 0];
Q=0.01*eye(4);
P = 100*eye(4);
dt=1;
A=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]'];
g = 6;
Bu = [0,0,0,g]';
kfinit=0;
x=zeros(100,4);
for i = 1 : 60
    Im = (imread(['DATA/',int2str(i), '.jpg']));
    imshow(Im)
    imshow(Im)
    Imwork = double(Im);
    [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);
    if flag==0
        continue
    end
    hold on
    for c = -1*radius: radius/20 : 1*radius
        r = sqrt(radius^2-c^2);
        plot(cc(i)+c,cr(i)+r,'g.')
        plot(cc(i)+c,cr(i)-r,'g.')
    end
    if kfinit==0
        xp = [MC/2,MR/2,0,0]' ;
    else
        xp=A*x(i-1,:)' + Bu;
    end
    kfinit=1;
    PP = A*P*A' + Q ;      
    K = PPP*H'*inv(H*PPP*H'+R);   % 此处有误，请修改为P73页一致即可运行
    x(i,:) = (xp + K*([cc(i),cr(i)]' - H*xp))';
    P = (eye(4)-K*H)*PP;
    hold on
    for c = -1*radius: radius/20 : 1*radius
        r = sqrt(radius^2-c^2);
        plot(x(i,1)+c,x(i,2)+r,'r.')  ;
        plot(x(i,1)+c,x(i,2)-r,'r.') ;
    end
    pause(0.3);
end
figure
t=1:60;
hold on; box on;
plot(t,cc(t),'-r*')
plot(t,x(t,1),'-b.')
figure
hold on; box on;
t=1:60;
plot(t,cr(t),'-g*')
plot(t,x(t,2),'-b.')
posn = [cc(55:60)',cr(55:60)'];
mp = mean(posn);
diffp = posn - ones(6,1)*mp;
Rnew = (diffp'*diffp)/5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

