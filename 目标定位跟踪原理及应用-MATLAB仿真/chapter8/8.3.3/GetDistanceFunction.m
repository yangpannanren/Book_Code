%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����S�������������źţ������������Ϣ
function [sys,x0,str,ts]=GetDistanceFunction(t,x,u,flag)
switch flag
    case 0  % ϵͳ���г�ʼ��������mdlInitializeSizes����
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  % ������ɢ״̬����������mdlUpdate����
        sys=mdlUpdate(t,x,u);
    case 3  % ����S���������������mdlOutputs
        sys=mdlOutputs(t,x,u);
    case {1,4,9}
        sys=[];
    otherwise   % ����δ֪��������û������Զ���
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1��ϵͳ��ʼ���Ӻ���
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;   % ��������
sizes.NumDiscStates  = 1;   % ��ɢ״̬4ά
sizes.NumOutputs     = 1;   % ���4ά��ӦΪ״̬����x-y�����λ�ú��ٶ�
sizes.NumInputs      = 2;   % ����ά������Ϊ����ģ����2ά��
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % ������Ҫ�Ĳ���ʱ��
sys = simsizes(sizes);
x0  = [0]';             % ��ʼ����
str = [];               % str��������Ϊ��
ts  = [-1 0];  % ��ʾ��ģ�����ʱ��̳���ǰ��ģ�����ʱ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2��������ɢ״̬�����ĸ���
function sys=mdlUpdate(t,x,u)
x0=0;y0=0; % �״�վ��λ��
d=sqrt( (u(1)-x0)^2+(u(2)-y0)^2 );
sys=d;  % ����ľ��뷵��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3����ȡϵͳ������ź�
function sys=mdlOutputs(t,x,u)
sys = x;  % ����õ�ģ�������������sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
