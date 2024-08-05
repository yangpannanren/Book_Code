trblk = randi([0 1],24,1,'int8');  
%指定物理层小区间标识号为321，系统帧号为10，后半帧。
nid = 321;  
sfn = 10;   
hrf = 1;    
%将候选SS/PBCH块的数量指定为8。当将候选SS/PBCH块的数量指定为4或8时，可以指定副载波偏移kssb作为BCH编码器的输入参数。
lssb = 8;                     
kssb = 18;    
%使用指定的参数对BCH传输块进行编码。
bch = nrBCH(trblk,sfn,hrf,lssb,kssb,nid);
%使用8位的极性解码列表长度对编码的传输块进行解码并恢复信息。
listLen = 8;
[~,errFlag,rxtrblk,rxSFN4lsb,rxHRF,rxKssb] = nrBCHDecode( ...
   double(1-2*bch),listLen,lssb,nid);
%验证解码是否有错误。
errFlag

isequal(trblk,rxtrblk)

isequal(bi2de(rxSFN4lsb','left-msb'),mod(sfn,16))

[isequal(hrf,rxHRF) isequal(de2bi(floor(kssb/16),1),rxKssb)]
