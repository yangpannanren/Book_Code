%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数说明：加载并展示电池数据
function LoadDataTest
% Battery_Capacity是来自美国马里兰大学关于电池测试的实验室数据
load Battery_Capacity
% 画图
figure
hold on;box on;
plot(A3Cycle,A3Capacity,'-g*');
plot(A5Cycle,A5Capacity,'r*')
plot(A8Cycle,A8Capacity,'-b*')
plot(A12Cycle,A12Capacity,'m*')
legend('A4','A2','A3','A1')
xlabel('cycle');ylabel('capacity');
title('电池容量退化数据')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%