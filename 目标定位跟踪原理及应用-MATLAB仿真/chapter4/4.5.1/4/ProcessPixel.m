%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ProcessPixel
mov=aviread('C:\Program Files\MATLAB71\work\video.avi')
totalFrame=size(mov,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imageLogo=imread('1.png');
imageSize= imresize(imageLogo,1);
[height width channel] = size(imageSize);
figure('Name','Processing Pixel')
for i=1:totalFrame
    frameData=mov(i).cdata;
    subplot(1,2,1);
    imshow(frameData)
    xlabel('The original video')
    for ii=1:height
        for jj=1:width
            for kk=1:channel
                frameData(ii,jj,kk)=imageLogo(ii,jj,kk);
            end
        end
    end
    subplot(1,2,2);
    imshow(frameData)
    xlabel('The processed video')
    pause(0.02);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

