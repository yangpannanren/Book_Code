pr = em.internal.makerectangle(0.5,0.5);
pr1 = em.internal.makerectangle(0.02,0.4);
pr2 = em.internal.makerectangle(0.03,0.008);
%创建一个半径为0.05米的圆。
ph = em.internal.makecircle(0.05);
%使用坐标[0 0.1 0]将第三个矩形平移到X-Y平面。
pf = em.internal.translateshape(pr2,[0 0.1 0]);
%使用指定的边界形状创建自定义槽天线单元。转置pr, ph, pr1和pf以确保边界输入是列向量数组。
c = customAntennaGeometry('Boundary',{pr',ph',pr1',pf'},...
    'Operation','P1-P2-P3+P4');
figure;
show(c);

c.FeedLocation = [0,0.1,0];
figure;
show(c);

%分析300 ~ 800 MHz天线阻抗。
figure;
impedance(c, linspace(300e6,800e6,51));


%分析天线在575 MHz的电流分布。
figure;
current(c,575e6)

figure;
pattern(c,575e6)