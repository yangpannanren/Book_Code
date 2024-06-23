%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  程序说明：这是一个视频捕获并录制的程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function VideoCapture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 首先：在命令行窗口查看一些必要的信息：
win_info=imaqhwinfo('winvideo')      % 获取适配器的信息
win_info.DeviceInfo.DeviceID         % 查看可用摄像头ID
win_info.DeviceInfo.SupportedFormats % 查看每个摄像头支持的视频格式

% 或者知道设备ID情况下，查看每个摄像头的详细支持信息，主要是支持的视频格式
% 这个要核实您的电脑是否有多个相机，默认用1，程序可检测多个相机
win_info=imaqhwinfo('winvideo',1)
%win_info=imaqhwinfo('winvideo',2)

% 通过上面两个指令获知：摄像头1支持视频格式为'MJPG_1280x480'，'MJPG_2560x720'
% 'MJPG_2560x960'，'MJPG_640x240'；
% 摄像头2支持的视频格式为'MJPG_1280x720'，'MJPG_640x360'，'MJPG_640x480'，
% 'MJPG_848x480'，'MJPG_960x540'，'YUY2_640x360'，'YUY2_640x480'。
% 以上代码可以删除，只是调试用，但是视频格式对下面代码有用。
%-----------------------------------------------------------
% 第1步： 视频的预览和采集
% 创建ID为1的摄像头的视频，视频格式为：MJPG_1280x720
video=videoinput('winvideo',1,'MJPG_1280x720');

set(video,'ReturnedColorSpace','rgb');  % 设置视频色彩
%set(video,'ReturnedColorSpace','grayscale');  % 与上面语句对比，这是灰度图像
vidReso=get(video,'VideoResolution')  % 获得视频的分辨率
width=vidReso(1)
height=vidReso(2)
nBands=get(video,'NumberOfBands')   % 色彩数目
%-----------------------------------------------------------
% 第2步，预览捕获的视频界面，相对简单
figure('Name','视频捕获效果展示','NumberTitle','Off','ToolBar','None','MenuBar','None')
hImage=image(zeros(height,width,nBands))
preview(video,hImage)

%-----------------------------------------------------------
% 第3步，把图像保存为视频文件
fileName='film'    % 保存视频的文件名字
nFrameNumber=500;  % 我们只保存500帧，就停止

writerObj=VideoWriter([fileName,'.avi']) % 创建一个写视频对象
writerObj.FrameRate=20;    % 每秒的帧数，也叫帧频
open(writerObj);

figure('Name','录制视频预览')
for i=1:nFrameNumber
    frame=getsnapshot(video);
    imshow(frame);
    f.cdata=frame;   % f是临时创建的一个结构体
    f.colormap=colormap([]);
    writeVideo(writerObj,f);
end

% 关闭写视频对象
close(writerObj);
closepreview;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%