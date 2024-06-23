%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ex2_25  % 主函数
X=[1,2,3]
Y=[115,23.1;     % 第1组数据
    39,97.1;     % 第2组数据
    17,246]      % 第3组数据
dx=0.1; % x方向的偏移量，主要是为了控制文本标记位置
dy=4;   % y方向的偏移量
figure; hold on; box on;
barh(X,Y,'grouped')
% 第1组数据
text(Y(1,1)+dy,X(1)-dx,['Running Speed: ',num2str(Y(1,1)),' FPS'])
text(Y(1,2)+dy,X(1)+2*dx,['Model Size: ',num2str(Y(1,2)),' MB'])
% 第2组数据
text(Y(2,1)+dy,X(2)-dx,['Running Speed: ',num2str(Y(2,1)),' FPS'])
text(Y(2,2)+dy,X(2)+2*dx,['Model Size: ',num2str(Y(2,2)),' MB'])
% 第3组数据
text(Y(3,1)+dy,X(3)-dx,['Running Speed: ',num2str(Y(3,1)),' FPS'])
text(Y(3,2)+dy,X(3)+2*dx,['Model Size: ',num2str(Y(3,2)),' MB'])
% 坐标轴的相关设置
set(gca,'YTick',[1,2,3])
set(gca,'YTickLabel',{'YOLO-v1','YOLO-v2','YOLO-v3'}); % 自定义刻度
axis([0,350,0.5,3.5])
colormap winter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%