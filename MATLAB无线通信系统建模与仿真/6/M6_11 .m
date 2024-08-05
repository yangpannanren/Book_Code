fco = invertedFcoplanar('Height',14e-3,'GroundPlaneLength', 100e-3, ...
      'GroundPlaneWidth', 100e-3);
  
  %创建一个pcbStack对象。
  p = pcbStack(fco);
show (p);
PW = PCBWriter(p)