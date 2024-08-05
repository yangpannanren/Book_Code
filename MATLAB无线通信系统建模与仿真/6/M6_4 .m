Lp  = 0.6;
Wp  = 0.5;
[~,p1]   = em.internal.makeplate(Lp,Wp,2,'linear');

Ls  = 0.05;
Ws  = 0.4;
offset = 0.12;
[~,p2]   = em.internal.makeplate(Ls,Ws,2,'linear');
p3 = em.internal.translateshape(p2, [offset, 0, 0]);
p2 = em.internal.translateshape(p2, [-offset, 0, 0]);
%在地平面的插槽之间创建一个要素。
Wf  = 0.01;
[~,p4]   = em.internal.makeplate(Ls,Wf,2,'linear');
p5 = em.internal.translateshape(p4, [offset, 0, 0]);
p4 = em.internal.translateshape(p4, [-offset, 0, 0]);

%可视化数组。
figure; show(carray);
%在350MHz ~ 450MHz的频率范围内计算阵列阻抗。
figure; impedance(carray, 350e6:5e6:450e6);
%可视化阵列在410MHz当前分布。
figure; current(carray, 410e6);