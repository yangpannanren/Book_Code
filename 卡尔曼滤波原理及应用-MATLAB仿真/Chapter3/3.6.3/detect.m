%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名：detect.m
% 功能说明：目标检测函数，主要完成将目标从背景中提取出来
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function detect
% 计算背景图片数目
Imzero = zeros(240,320,3);
for i = 1:5
    % 将图像文件 i.jpg 的图像像素数据读入矩阵Im
    Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
    Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
% 遍历所有图片
for i = 1 : 60
    % 读取所有帧
    Im = (imread(['DATA/',int2str(i), '.jpg']));
    imshow(Im); %显示图像Im ,图像对比度低
    Imwork = double(Im);
    % 检测目标
    [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);%,fig1,fig2,fig3,fig15,i);
    if flag == 0 % 没检测到目标，继续下一帧图像
        continue
    end
    hold on
    for c = -0.9*radius: radius/20 : 0.9*radius
        r = sqrt(radius^2-c^2);
        plot(cc(i)+c,cr(i)+r,'g.')
        plot(cc(i)+c,cr(i)-r,'g.')
    end
    %Slow motion!
    pause(0.02)
end
% 目标中心的位置，也就是目标的x、y坐标
figure
plot(cr,'-g*')
hold on
plot(cc,'-r*')
xlabel('帧数');ylabel('数值');
legend('y方向','x方向')