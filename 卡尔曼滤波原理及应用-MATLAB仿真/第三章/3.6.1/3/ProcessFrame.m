%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������������ȡAVI������AVI��Ƶ��ÿһ֡תΪbmpͼƬ�洢
%  ��ϸԭ����ܼ�����ע����ο���
%  ���������˲�ԭ��Ӧ��-MATLAB���桷�����ӹ�ҵ�����磬��Сƽ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
