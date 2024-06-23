%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ex2_26
figure
subplot(1,2,1);  % 简单的饼图绘制
x = [0.14, 0.24, 0.05, 0.47, 0.1];
pie(x);
set(gcf,'color','white')
subplot(1,2,2);  % 稍微复杂点的饼图绘制
money=[5 10 7 15];                 % 输入数据
name={'George','Sam','Betty','Charlie'};   %输入标签
explode=[0 1 0 0];                 % 定义突出的部分
bili=money/sum(money);             % 计算比例
baifenbi=round(bili*10000)/100;    % 计算百分比
baifenbi=num2str(baifenbi');       % 转化为字符型
baifenbi=cellstr(baifenbi);        % 转化为字符串数组
%在每个姓名后加2个空格
for i=1:length(name)
    name(i)={[name{i},blanks(2)]};
end
bfh=cellstr(repmat('%',length(money),1));  %创建百分号字符串数组
c=strcat(name,baifenbi',bfh');
pie(money,explode,c)
