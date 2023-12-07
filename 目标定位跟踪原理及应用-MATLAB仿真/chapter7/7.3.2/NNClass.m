%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：
% 单站多目标跟踪的建模程序，并用近邻法分类
% 主要模拟多目标的运动和观测过程，涉及融合算法---近邻法
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 分类算法子函数
% Xun为输入的未知样本集合
% XX为输入的已知样本集合（种子样本）
% XXout为最终分好类别的样本集合
function [XXout,ZZout]=NNClass(Xun,XX,Zun,ZZ)
ALL=length(Xun(1,:));   % 剩余未知样本点个数
Type=length(XX);
% 从已知样本点出发，找到最近的未知样本点
while (ALL>0)
    % 近邻法跟开始分类的顺序有关，顺序不一样，分类的结果也不一样
    d=1e5; % 为了要找到最近的样本，假定初始距离无穷大
    for i=1:Type
        % 去寻找离第i类距离最近的样本
        [row,col]=size(XX{i}); % 得到第i类已知类别的样本中的样本数
        for j=1:col
            % 找到离已知样本点最近的点
            for k=1:ALL
                dist=sqrt( (Xun(1,k)-XX{i}(1,j))^2+(Xun(2,k)-XX{i}(2,j))^2 );
                if dist<d
                    d=dist;
                    % 最近的已知-未知样本序列对
                    label.class=i; % 存放已知类别的样本的标号
                    label.unclass=k; % 存放未知类别的样本的标号
                    X0=[Xun(1,k),XX{i}(1,j)];
                    Y0=[Xun(2,k),XX{i}(2,j)];
                end
            end
        end
    end
    % 将距离近的点归并到第label.class类
    XX{label.class}=[XX{label.class},Xun(:,label.unclass)];
    ZZ{label.class}=[ZZ{label.class},Zun(:,label.unclass)];
    line(X0,Y0);  % 与最近的样本同类，两者之间连线
    pause(0.5);    % 设置停止时间可以在图形界面上看分类过程
    % 同时将Xun的第label个样本删除
    Xun(:,label.unclass)=[];
    Zun(:,label.unclass)=[];
    % 继续遍历其他类
    ALL=ALL-1;
end
XXout=XX;
ZZout=ZZ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
