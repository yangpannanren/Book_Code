%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  程序说明：读取视频文件并播放
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReadAndShowAVI
fileName = 'video.avi';
v = VideoReader(fileName)
figure('Name','ReadAndShowAVI')
% 第一种方法，通过总帧数来控制预览视频的时长
% numFrames = v.NumberOfFrames  % 帧的总数
% for k = 1 : numFrames % 读取数据
%     frame = read(v,k);
%     imshow(frame);%显示帧
% end

% 第二种方法，也是MATLAB推荐的方法
while hasFrame(v)
    frame = readFrame(v);
    imshow(frame);   %  显示帧
    pause(0.1)
end
whos frame  % 查看其中一帧的信息