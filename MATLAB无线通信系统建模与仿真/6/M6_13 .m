fco = invertedFcoplanar('Height',14e-3,'GroundPlaneLength', 100e-3,  ...
                  'GroundPlaneWidth', 100e-3);
%使用这个天线来创建一个pcbStack对象。
p = pcbStack(fco);
%使用Coax_RG11 RF连接器，引脚直径为2mm。
c = PCBConnectors.Coax_RG11;
c.PinDiameter = 2.000e-03
s = PCBServices.MayhewWriter;
PW = PCBWriter(p,s,c);
gerberWrite(PW)

