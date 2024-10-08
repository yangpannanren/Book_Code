%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  功能描述：读取AVI，并将AVI视频的每一帧转为bmp图片存储
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ProcessFrame
fileName = 'video.avi';  % 文件名，注意视频文件与本程序放在同一个目录下
v = VideoReader(fileName)     % 创建读取视频对象
numFrames = v.NumFrames  % 帧的总数
% 将读取的视频显示
figure('Name','show the movie');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 将每一帧转为bmp图片序列，在work文件夹下创建空文件夹imageFrame
for k=1:numFrames
    frame = read(v,k);   % 获取视频帧
    imshow(frame);       % 显示帧
    %对每一帧序列命名并且编号
    bmpName=strcat(int2str(k),'.bmp');
    %把每帧图像存入硬盘 
    imwrite(frame,bmpName,'bmp');
    pause(0.02);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
