%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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