%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：第一个M程序，做简单的数值计算、输出、画图
% 详细原理介绍请参考：
% 《卡尔曼滤波原理及应用-MATLAB仿真》，电子工业出版社，黄小平著。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数值计算，语句结束不加分号，可以在命令窗口查看结果
value=sin(pi/4)+cos(1)+log(2)
% 在命令窗口输出文本
disp('Hello World');
% 画一个正弦函数
t=0:0.5:2*pi;
y=sin(t);
plot(t,y,'-ko','MarkerFace','g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
