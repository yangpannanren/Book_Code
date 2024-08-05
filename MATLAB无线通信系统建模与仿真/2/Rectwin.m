n = 50;
w = rectwin(n);
w = ones(50,1);
windowDesigner
Bartlett = bartlett(7);
isequal(Bartlett(2:end-1),triang(5))
w = bartlett(8); 
[w(2:7) triang(6)]

zerophase(bartlett(10))
hold on
zerophase(triang(10))
legend('Bartlett窗','三角窗')
axis([0.3 1 -0.2 0.5])
title('零相位响应');