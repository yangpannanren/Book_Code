%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这是一个测试画图的程序，用于画不同的线型
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
A1=randn(1,10);
A2=randn(1,10);
A3=randn(1,10);

figure 
box on
hold on; 
plot(A1,'-r') 
plot(A2,'-.g') 
plot(A3,'-b.')
xlabel('X-axis')
ylabel('Y-axis')

figure
box on
hold on; 
plot(A1,'-ko','MarkerFaceColor','r') 
plot(A2,'-cd','MarkerFaceColor','g') 
plot(A3,'-bs','MarkerFaceColor','b')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%