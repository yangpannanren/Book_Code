%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function VideoCapture
aviobj = avifile('myAVI');
obj=videoinput('winvideo',1,'YUY2_320x240');
preview(obj);                
T=100;
k=0;
while (k<T)
    frame=getsnapshot(obj);     
    subplot(1,2,1)
    imshow(frame);
    frameRGB=ycbcr2rgb(frame);     
    subplot(1,2,2);
    imshow(frameRGB);
    drawnow;
    aviobj=addframe(aviobj,frameRGB);
    flushdata(obj)
    k=k+1
end
aviobj = close(aviobj); 
delete(obj); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
