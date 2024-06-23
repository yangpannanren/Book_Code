%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ex2_23  % 主函数
A1=randn(1,10);
A2=randn(1,10);
A3=randn(1,10);
figure            % 画图1
box on
hold on;          %在同一个figure中多次调用plot，需要hold
plot(A1,'-r')       % 红色的实线,线的宽度默认值
plot(A2,'-.g','LineWidth',5)   %绿色的点画线，线的宽度为5
plot(A3,'-b.','LineWidth',10)  %蓝色的实线，数据点为黑实点，线的宽度为10
xlabel('X-axis')
ylabel('Y-axis')
figure           % 画图2
box on
hold on; %在同一个figure中多次调用plot，需要hold
plot(A1,'-ko','MarkerFaceColor','r') %黑色实线，红色圆圈数据点
plot(A2,'-cd','MarkerFaceColor','g') %蓝绿色实线，绿色菱形数据点
%蓝色实线，蓝色方形数据点，同样也可以设置线的宽度
plot(A3,'-bs','MarkerFaceColor','b','LineWidth',5)