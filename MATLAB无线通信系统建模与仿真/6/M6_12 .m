%创建一个共面倒F天线。
fco = invertedFcoplanar('Height',14e-3,'GroundPlaneLength', 100e-3,  ...
                  'GroundPlaneWidth', 100e-3);
%在创建PCB堆栈对象时使用该天线。
p = pcbStack(fco);
%使用Mayhew Writer与配置板查看PCB的3D。
s = PCBServices.MayhewWriter;
s.BoardProfileFile = 'profile'

