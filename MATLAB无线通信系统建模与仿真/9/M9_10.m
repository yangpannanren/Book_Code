trblk = randi([0 1],24,1,'int8');  
%指定物理层小区间标识号为321，系统帧号为10，后半帧。
nid = 321;  
sfn = 10;   
hrf = 1;    
%将候选SS/PBCH块的数量指定为8。当将候选SS/PBCH块的数量指定为4或8时，可以指定副载波偏移kssb作为BCH编码器的输入参数。
lssb = 8;                     
kssb = 18;    
%使用指定的参数对 BCH 传输块进行编码。
cdblk = nrBCH(trblk,sfn,hrf,lssb,kssb,nid);
%当指定候选SS/PBCH块数为64时，可以指定SS块索引ssbIdx作为输入参数，而不是子载波偏移kssb。
lssb = 64;                     
ssbIdx = 13;    
%使用更新的输入参数对 BCH 传输块进行编码。
cdblk2 = nrBCH(trblk,sfn,hrf,lssb,ssbIdx,nid)