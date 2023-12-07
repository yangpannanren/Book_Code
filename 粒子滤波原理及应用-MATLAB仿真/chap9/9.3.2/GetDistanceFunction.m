%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����S�������������źţ������������Ϣ
function [sys,x0,str,ts]=GetDistanceFunction(t,x,u,flag)
switch flag
    case 0   
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  
        sys=mdlUpdate(t,x,u);
    case 3  
        sys=mdlOutputs(t,x,u);
    case {1,4,9}
        sys=[];
    otherwise    
        error(['Unhandled flag = ',num2str(flag)]);
end
 
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;   
sizes.NumDiscStates  = 1;    
sizes.NumOutputs     = 1;    
sizes.NumInputs      = 2;    
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;    
sys = simsizes(sizes);
x0  = [0]';              
str = [];               
ts  = [-1 0];   
 
function sys=mdlUpdate(t,x,u)
x0=0;y0=0;  
d=sqrt( (u(1)-x0)^2+(u(2)-y0)^2 );
sys=d;   
 
function sys=mdlOutputs(t,x,u)
sys = x;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
