clear all;
h = rcosdesign(0.25,6,4);
mx = max(abs(h-rcosdesign(0.25,6,4,'sqrt')))
fvtool(h,'Analysis','impulse')
title('脉冲响应');
xlabel('样本');ylabel('幅度')
h2 = rcosdesign(rf,span,sps,'sqrt');
fvtool(h2,'impulse')