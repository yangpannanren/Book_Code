function [ u ] = Model_P_up( r1, r2, r3, S1, S2, S3, c_i )
% ģ�͸��ʸ��º���
% u ģ�͸���
% r1 ģ��1Ԥ�����
% r2 ģ��2Ԥ�����
% r3 ģ��3Ԥ�����
% S1 ģ��1Ԥ�����Э�������
% S2 ģ��2Ԥ�����Э�������
% S3 ģ��3Ԥ�����Э�������
% c_i ģ�ͻ�ϸ���

% ������Ȼ����
Lfun1 = (1/sqrt(abs(2*pi*det(S1))))*exp(-1/2*(r1'*inv(S1)*r1));
Lfun2 = (1/sqrt(abs(2*pi*det(S2))))*exp(-1/2*(r2'*inv(S2)*r2));
Lfun3 = (1/sqrt(abs(2*pi*det(S3))))*exp(-1/2*(r3'*inv(S3)*r3));
% ��һ��
Lfun1_new = Lfun1/(Lfun1+Lfun2+Lfun3);
Lfun2_new = Lfun2/(Lfun1 + Lfun2 + Lfun3);
Lfun3_new = Lfun3/(Lfun1 + Lfun2 + Lfun3);
c = [Lfun1_new, Lfun2_new, Lfun3_new]*c_i;
u = (1/c).*[Lfun1_new, Lfun2_new, Lfun3_new]'.*c_i;


end

