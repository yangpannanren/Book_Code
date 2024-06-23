%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  功能说明：加载并展示电池数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数说明：加载并展示电池数据
function LoadDataTest
% Battery_Capacity是来自美国马里兰大学大学关于电池测试的实验室数据
load Battery_Capacity
% 画图显示
figure
hold on;
box on;
plot(A3Cycle,A3Capacity,'-g*');
plot(A5Cycle,A5Capacity,'r*')
plot(A8Cycle,A8Capacity,'-b*')
plot(A12Cycle,A12Capacity,'m*')
xlabel('cycle');ylabel('capacity');
legend('A1','A2','A3','A4');
title('电池容量退化数据');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%