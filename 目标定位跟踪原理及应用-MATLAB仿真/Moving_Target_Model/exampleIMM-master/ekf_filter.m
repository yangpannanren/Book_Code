function x_est = ekf_filter( x_init, y, f, df, h, dh, Q, R, T )
%% ������ʵ����չ�������˲���Extended Kalman Filter����
%% ���������
% x_init��״̬�����ĳ�ʼ����ֵ��
% y��ȫ���̵Ĳ���ֵ��
% f��״̬ת�Ʒ��̡�
% df��״̬ת�Ʒ�������Ӧ��Jacobian������㷽����Ϊһ��function��
% h���������̡�
% dh��������������Ӧ��Jacobian������㷽����Ϊһ��function��
% Q��״̬ת�ƹ����еļ�����������Ӧ��Э�������
% R�����������еļ�����������Ӧ��Э�������
%% ���������
% x_est��״̬����ֵ
%% ���ݳ�ʼ��
N1 = size(Q,1);         % ״̬����ά��
% N2 = size(R,1);         % ����ֵά��
Time = size(y,2);       % ����ʱ��
P = eye(N1);
x_est = zeros(N1, Time);
for t = 1:Time
    if t == 1
        x_est(:,1) = x_init;
    else
        [x_est(:,t), P] = ekf_update(x_est(:,t-1), y(:,t), f, df, h, dh, P, Q, R, T);
    end
end
end

