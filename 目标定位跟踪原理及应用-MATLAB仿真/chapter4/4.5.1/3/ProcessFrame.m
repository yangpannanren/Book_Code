%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
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
