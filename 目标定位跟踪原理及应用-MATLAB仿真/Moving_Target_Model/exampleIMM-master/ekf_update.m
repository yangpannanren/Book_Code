function [ xNew, P_new, e, S ] = ekf_update( x, y, f, df, h , dh, P_old, Q, R )
%% ������ʵ����չ�������˲���Extended Kalman Filter���ĵ������������
%% ���������
% x����һʱ�̵Ĺ���ֵ��
% y����ʱ�̵Ĳ���ֵ��
% f��״̬ת�Ʒ���
% df��״̬ת�Ʒ�������Ӧ��Jacobian������㷽����Ϊһ��function��
% h���������̡�
% dh��������������Ӧ��Jacobian������㷽����Ϊһ��function��
% P_old����һʱ�̹��Ƶ�״̬������Э�������
% Q��״̬ת�ƹ����еļ�����������Ӧ��Э�������
% R�����������еļ�����������Ӧ��Э�������
%% ���������
% xNew����ʱ�̵Ĺ���ֵ
% P_new����ʱ�̵�״̬������Э�������ֵ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ԥ�����
x_temp = f(x);
F = df(x_temp);
P_temp = F * P_old * (F') + Q;
%% ���¹��̣�
H = dh(x_temp);
S = H * P_temp * (H') + R;
K = P_temp * (H') / S;
e = y - h(x_temp);
xNew = x_temp + K * ( y - h(x_temp) );
P_new = P_temp - K * S * (K');
end

