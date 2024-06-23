%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  功能描述：操作视频帧中的像素，在每一帧中打上标签
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ProcessPixel
% 读取存放在工作目录下的video.avi
fileName = 'video.avi';  % 文件名，注意视频文件与本程序放在同一个目录下
v = VideoReader(fileName);     % 创建读取视频对象
% 读取一张logo图像，用于替换视频的某一部分
imageLogo=imread('logo.png'); 
% 获取图像的大小，第二个参数不能大于1，是缩放参数（即原图像的0.5倍）
imageSize= imresize(imageLogo,1);
% 读者可以准备一张灰度图像，看看下面的channel是多少
[height, width, channel] = size(imageSize)
% 读取所有的帧
figure('Name','Video Pixel Processing')
while hasFrame(v)
    % 获取视频帧，非常重要
    frame=readFrame(v);
    % 将原视频显示在左边
    subplot(1,2,1);
    imshow(frame);  
    xlabel('The original video')
    % 下面对原图像进行像素级别的修改
    frameCopy=frame;
    for i=1:height
        for j=1:width
            for k=1:channel
                %像素复制（替换）
                frameCopy(i,j,k)=imageLogo(i,j,k);
                % 读者可以尝试改成其他值，如下：
                % frameCopy(i,j,k)=255; 
            end
        end
    end
    %将处理过的视频放在右边
    subplot(1,2,2);
    imshow(frameCopy)
    xlabel('The processed video')
    pause(0.1)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%