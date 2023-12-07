%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目标检测函数，这个函数主要完成将目标从背景中提取出来
%  详细原理介绍及中文注释请参考：
%  《卡尔曼滤波原理及应用-MATLAB仿真》，电子工业出版社，黄小平著。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function detect
clear,clc;
Imzero = zeros(240,320,3);
for i = 1:5
    Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
    Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
for i = 1 : 60
    Im = (imread(['DATA/',int2str(i), '.jpg']));
    imshow(Im); 
    Imwork = double(Im);
    [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,ii);% 此处有误，请修改为P70页一致即可运行
    if flag==0
        continue
    end
    hold on
    for c = -0.9*radius: radius/20 : 0.9*radius
        r = sqrt(radius^2-c^2);
        plot(cc(i)+c,cr(i)+r,'g.')
        plot(cc(i)+c,cr(i)-r,'g.')
    end
    pause(0.02)
end
figure
plot(cr,'-g*')
hold on
plot(cc,'-r*')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%