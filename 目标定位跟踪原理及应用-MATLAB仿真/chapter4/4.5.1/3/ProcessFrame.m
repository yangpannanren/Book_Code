%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ProcessFrame
mov=aviread('C:\Program Files\MATLAB71\work\video.avi')
totalFrame=size(mov,2);
figure('Name','show the movie');
movie(mov);
for i=1:totalFrame
    frameData=mov(i).cdata;
    bmpName=strcat('C:\Program Files\MATLAB71\work\imageFrame\image',...
        int2str(i),'.bmp');
    imwrite(frameData,bmpName,'bmp');
    pause(0.02);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
