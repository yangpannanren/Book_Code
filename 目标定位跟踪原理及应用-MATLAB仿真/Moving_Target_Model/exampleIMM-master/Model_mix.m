function [ x_pro, P ] = Model_mix( x1, x2,P1, P2, u, x3, P3  )
% ģ���ۺϺ���
% x_pro ״̬�ۺ�ֵ
% p �ۺ�Э�������
% x1 ģ��1״̬����ֵ
% x2 ģ��2״̬����ֵ
% x3 ģ��3״̬����ֵ
% P1 ģ��1״̬����Э�������
% P2 ģ��2״̬����Э�������
% P3 ģ��3״̬����Э�������
% u ģ��ת������
if nargin == 7
    x_pro = x1*u(1) + x2*u(2) + x3*u(3);
    P = u(1)*(P1 + (x1 - x_pro)*((x1-x_pro)'))+...
            u(2)*(P2 + (x2-x_pro)*((x2-x_pro)')) + ...
            u(3)*(P3+(x3-x_pro)*((x3-x_pro)'));
elseif nargin == 5
    x_pro = x1*u(1) + x2*u(2);
    P = u(1)*(P1 + (x1 - x_pro)*((x1-x_pro)'))+...
            u(2)*(P2 + (x2-x_pro)*((x2-x_pro)'));
else
    disp('Some parameters are not specific.');
    return;
end
end

