%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����S��������ϵͳ��״̬����X(k+1)=F*x(k)+G*w(k)
function [sys,x0,str,ts]=SimuStateFunction(t,x,u,flag)
global Xstate;
switch flag
    case 0  % ϵͳ���г�ʼ��������mdlInitializeSizes����
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  % ������ɢ״̬����������mdlUpdate����
        sys=mdlUpdate(t,x,u);
    case 3  % ����S���������������mdlOutputs
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9   % �������������״ֵ̬
        save('Xstate','Xstate');
    otherwise   % ����δ֪��������û������Զ���
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1��ϵͳ��ʼ���Ӻ���
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;   % ��������
sizes.NumDiscStates  = 4;   % ��ɢ״̬4ά
sizes.NumOutputs     = 4;   % ���4ά��ӦΪ״̬����x-y�����λ�ú��ٶ�
sizes.NumInputs      = 2;   % ����ά������Ϊ����ģ����2ά��
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % ������Ҫ�Ĳ���ʱ��
sys = simsizes(sizes);
x0  = [10,10,12,10]';             % ��ʼ����
str = [];               % str��������Ϊ��
ts  = [-1 0];  % ��ʾ��ģ�����ʱ��̳���ǰ��ģ�����ʱ������
global Xstate;
Xstate=[];
Xstate=[Xstate,x0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2��������ɢ״̬�����ĸ���
function sys=mdlUpdate(t,x,u)
G=[0.5,0;1,0;0,0.5;0,1];
F=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1];
x_next=F*x+G*u;
sys=x_next;
global Xstate;
Xstate=[Xstate,x_next];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3����ȡϵͳ������ź�
function sys=mdlOutputs(t,x,u)
sys = x;  % ����õ�ģ�������������sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
