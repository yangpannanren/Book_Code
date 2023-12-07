%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 提取目标区域的中心和能包含目标的最大半径
%  详细原理介绍及中文注释请参考：
%  《卡尔曼滤波原理及应用-MATLAB仿真》，电子工业出版社，黄小平著。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cc,cr,radius,flag]=extractball(Imwork,Imback,index)
cc = 0;
cr = 0;
radius = 0;
flag = 0;
[MR,MC,Dim] = size(Imback);
fore = zeros(MR,MC);          
fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > 10) ...
    | (abs(Imwork(:,:,2) - Imback(:,:,2)) > 10) ...
    | (abs(Imwork(:,:,3) - Imback(:,:,3)) > 10);
foremm = bwmorph(fore,'erode',2);
labeled = bwlabel(foremm,4);
stats = regionprops(labeled,['basic']);
[N,W] = size(stats);
if N < 1
    return
end
id = zeros(N);
for i = 1 : N
    id(i) = i;
end
for i = 1 : N-1
    for j = i+1 : N
        if stats(i).Area < stats(j).Area
            tmp = stats(i);
            stats(i) = stats(j);
            stats(j) = tmp;
            tmp = id(i);
            id(i) = id(j);
            id(j) = tmp;
        end
    end
end
if stats(1).Area < 100
    return
end
selected = (labeled==id(1));
centroid = stats(1).Centroid;
radius = sqrt(stats(1).Area/pi);
cc = centroid(1);
cr = centroid(2);
flag = 1;
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%