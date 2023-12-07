%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function detect
clear,clc;
Imzero = zeros(240,320,3);
for i = 1:5
    Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
    Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
for i = 1 : 60
    Im = (imread(['DATA/',int2str(i), '.jpg']));
    imshow(Im); 
    Imwork = double(Im);
    [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,ii);% �˴��������޸�ΪP70ҳһ�¼�������
    if flag==0
        continue
    end
    hold on
    for c = -0.9*radius: radius/20 : 0.9*radius
        r = sqrt(radius^2-c^2);
        plot(cc(i)+c,cr(i)+r,'g.')
        plot(cc(i)+c,cr(i)-r,'g.')
    end
    pause(0.02)
end
figure
plot(cr,'-g*')
hold on
plot(cc,'-r*')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%