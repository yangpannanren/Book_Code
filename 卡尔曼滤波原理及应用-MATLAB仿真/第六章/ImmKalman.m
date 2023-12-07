%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ������ģKalman�˲���Ŀ������е�Ӧ��
%   ��ϸԭ����ܼ�����ע����ο���
%  ���������˲�ԭ��Ӧ��-MATLAB���桷�����ӹ�ҵ�����磬��Сƽ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ImmKalman
clear;
T=2;
M=50;
N=900/T;
N1=400/T;
N2=600/T;
N3=610/T;
N4=660/T;
Delta=100;
Rx=zeros(N,1);
Ry=zeros(N,1);
Zx=zeros(N,MM);  % �˴��д����޸�Ϊ����P126һ�¼���
Zy=zeros(N,M);
t=2:T:400;
x0=2000+0*t';
y0=10000-15*t';
t=402:T:600;
x1=x0(N1)+0.075*((t'-400).^2)/2;
y1=y0(N1)-15*(t'-400)+0.075*((t'-400).^2)/2;
t=602:T:610;
vx=0.075*(600-400);
x2=x1(N2-N1)+vx*(t'-600);
y2=y1(N2-N1)+0*t';
t=612:T:660;
x3=x2(N3-N2)+(vx*(t'-610)-0.3*((t'-610).^2)/2);
y3=y2(N3-N2)-0.3*((t'-610).^2)/2;
t=662:T:900;
vy=-0.3*(660-610);
x4=x3(N4-N3)+0*t';
y4=y3(N4-N3)+vy*(t'-660);
Rx=[x0;x1;x2;x3;x4];
Ry=[y0;y1;y2;y3;y4];
Mt_Est_Px=zeros(M,N);
Mt_Est_Py=zeros(M,N);

nx=randn(N,M)*Delta;
ny=randn(N,M)*Delta;
Zx=Rx*ones(1,M)+nx;
Zy=Ry*ones(1,M)+ny;
for m=1:M
    Mt_Est_Px(m,1)=Zx(1,m);
    Mt_Est_Py(m,1)=Zx(2,m);
    xn(1)=Zx(1,m);
    xn(2)=Zx(2,m);
    yn(1)=Zy(1,m);
    yn(2)=Zy(2,m);
    phi=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
    h=[1,0,0,0;0,0,1,0];
    g=[T/2,0;1,0;0,T/2;0,1];
    q=[Delta^2,0;0,Delta^2];
    vx=(Zx(2)-Zx(1,m))/2;
    vy=(Zy(2)-Zy(1,m))/2;
    x_est=[Zx(2,m);vx;Zy(2,m);vy];
    p_est=[Delta^2,Delta^2/T,0,0;Delta^2/T,2*Delta^2/(T^2),0,0;
        0,0,Delta^2,Delta^2/T;0,0,Delta^2/T,2*Delta^2/(T^2)];
    Mt_Est_Px(m,2)=x_est(1);
    Mt_Est_Py(m,2)=x_est(3);
    for r=3:N
        z=[Zx(r,m);Zy(r,m)];
        if r<20
            x_pre=phi*x_est;
            p_pre=phi*p_est*phi';
            k=p_pre*h'*inv(h*p_pre*h'+q);
            x_est=x_pre+k*(z-h*x_pre);
            p_est=(eye(4)-k*h)*p_pre;
            xn(r)=x_est(1);
            yn(r)=x_est(3);
            Mt_Est_Px(m,r)=x_est(1);
            Mt_Est_Py(m,r)=x_est(3);
        else
            if r==20
                X_est=[x_est;0;0];
                P_est=p_est;
                P_est(6,6)=0;
                for i=1:3
                    Xn_est{i,1}=X_est;
                    Pn_est{i,1}=P_est;
                end
                u=[0.8,0.1,0.1];
            end
            [X_est,P_est,Xn_est,Pn_est,u]=IMM(Xn_est,Pn_est,T,z,Delta,u);
            xn(r)=X_est(1);
            yn(r)=X_est(3);
            Mt_Est_Px(m,r)=X_est(1);
            Mt_Est_Py(m,r)=X_est(3);
        end
    end
end
err_x=zeros(N,1);
err_y=zeros(N,1);
delta_x=zeros(N,1);
delta_y=zeros(N,1);
for r=1:N
    ex=sum(Rx(r)-Mt_Est_Px(:,r));
    ey=sum(Ry(r)-Mt_Est_Py(:,r));
    err_x(r)=ex/M;
    err_y(r)=ey/M;
    eqx=sum((Rx(r)-Mt_Est_Px(:,r)).^2);
    eqy=sum((Ry(r)-Mt_Est_Py(:,r)).^2);
    delta_x(r)=sqrt(abs(eqx/M-(err_x(r)^2)));
    delta_y(r)=sqrt(abs(eqy/M-(err_y(r)^2)));
end
figure(1);
plot(Rx,Ry,'k-',Zx,Zy,'g:',xn,yn,'r-.');
legend('��ʵ�켣','�۲�����','���ƹ켣');
figure(2);
subplot(2,1,1);
plot(err_x);
%axis([1,N,-300,300]);
title('x�����������ֵ');
subplot(2,1,2);
plot(err_y);
%axis([1,N,-300,300]);
title('y�����������ֵ');
figure(3);
subplot(2,1,1);
plot(delta_x);
%axis([1,N,0,1]);
title('x�����������׼��');
subplot(2,1,2);
plot(delta_y);
%axis([1,N,0,1]);
title('y�����������׼��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_est,P_est,Xn_est,Pn_est,u]=IMM(Xn_est,Pn_est,T,Z,Delta,u)
P=[0.95,0.025,0.025;0.025,0.95,0.025;0.025,0.025,0.95];
PHI{1,1}=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
PHI{1,1}(6,6)=0;
PHI{2,1}=[1,T,0,0,T^2/2,0;0,1,0,0,T,0;0,0,1,T,0,T^2/2;
    0,0,0,1,0,T;0,0,0,0,1,0;0,0,0,0,0,1];
PHI{3,1}=PHI{2,1};
G{1,1}=[T/2,0;1,0;0,T/2;0,1];
G{1,1}(6,2)=0;
G{2,1}=[T^2/4,0;T/2,0;0,T^2/4;0,T/2;1,0;0,1];
G{3,1}=G{2,1};
Q{1,1}=zeros(2);
Q{2,1}=0.001*eye(2);
Q{3,1}=0.0114*eye(2);
H=[1,0,0,0,0,0;0,0,1,0,0,0];
R=eye(2)*Delta^2;
mu=zeros(3,3);
c_mean=zeros(1,3);
for i=1:3
    c_mean=c_mean+P(i,:)*u(i);
end
for i=1:3
    mu(i,:)=P(i,:)*u(i)./c_mean;
end
for j=1:3
    X0{j,1}=zeros(6,1);
    P0{j,1}=zeros(6);
    for i=1:3
        X0{j,1}=X0{j,1}+Xn_est{i,1}*mu(i,j);
    end
    for i=1:3
        P0{j,1}=P0{j,1}+mu(i,j)*( Pn_est{i,1}...
            +(Xn_est{i,1}-X0{j,1})*(Xn_est{i,1}-X0{j,1})');
    end
end
a=zeros(1,3);
for j=1:3
    X_pre{j,1}=PHI{j,1}*X0{j,1};
    P_pre{j,1}=PHI{j,1}*P0{j,1}*PHI{j,1}'+G{j,1}*Q{j,1}*G{j,1}';
    K{j,1}=P_pre{j,1}*H'*inv(H*P_pre{j,1}*H'+R);
    Xn_est{j,1}=X_pre{j,1}+K{j,1}*(Z-H*X_pre{j,1});
    Pn_est{j,1}=(eye(6)-K{j,1}*H)*P_pre{j,1};
end
for j=1:3
    v{j,1}=Z-H*X_pre{j,1};
    s{j,1}=H*P_pre{j,1}*H'+R;
    n=length(s{j,1})/2;
    a(1,j)=1/((2*pi)^n*sqrt(det(s{j,1})))*exp(-0.5*v{j,1}'...
        *inv(s{j,1})*v{j,1});
end
c=sum(a.*c_mean);
u=a.*c_mean./c;
Xn=zeros(6,1);
Pn=zeros(6);
for j=1:3
    Xn=Xn+Xn_est{j,1}.*u(j);
end
for j=1:3
    Pn=Pn+u(j).*(Pn_est{j,1}+(Xn_est{j,1}-Xn)*(Xn_est{j,1}-Xn)');
end
X_est=Xn;
P_est=Pn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
