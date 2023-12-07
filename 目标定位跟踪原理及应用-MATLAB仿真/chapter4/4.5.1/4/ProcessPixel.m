%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
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

