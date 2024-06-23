%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ex2_22
xmin=-pi;   % x的最小值
xmax=pi;    % x的最大值
ymin=-pi;  % y的最小值
ymax=pi;   % y的最大值
% 测试两个函数曲线
x=xmin:pi/3:xmax;
y1=x;
y2=sin(x);
% figure的使用
figure('Name','坐标轴综合设置','Color','white','Position',[200,200,600,300]);
subplot(1,2,1);        % 第一个子图
plot(x,y1,'-r*');
%  第一个子图的标题设置
title(['第一行：','\pi=',num2str(3.14),newline,'第二行：','y=x'])
text(0,0,'原点O','FontSize',14,'Color','blue');
axis([xmin,xmax,ymin,ymax]);   % 坐标轴的范围设置
subplot(1,2,2);   % 第二个子图
plot(x,y2,'-bo');
title('绘制曲线：y=sin(x)','Color','red','FontSize',14)
set(gca,'XTicklabel',{'-pi','-2pi/3','-pi/3','0','pi/3','2pi/3','pi'})  % 自定义x轴坐标的刻度
text(0,0,'原点O','FontSize',14,'Color','red');
axis([xmin,xmax,ymin,ymax]);   % 坐标轴的范围设置