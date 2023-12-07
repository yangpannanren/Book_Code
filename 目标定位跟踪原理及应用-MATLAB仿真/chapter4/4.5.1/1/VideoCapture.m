%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
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
