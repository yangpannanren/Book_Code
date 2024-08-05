trBlkLen = 5120;
trBlk = randi([0 1],trBlkLen,1,'int8');
%使用指定的目标码率创建和配置 DL-SCH 编码器系统对象。
targetCodeRate = 567/1024;
encDL = nrDLSCH;
encDL.TargetCodeRate = targetCodeRate;
%将传输块加载到 DL-SCH 编码器中。
setTransportBlock(encDL,trBlk);
%调用64-QAM 调制方案、1个传输层、10,240位输出长度和冗余版本0的编码器。编码器将DL-SCH处理链应用于加载到对象中的传输块。
mod = '64QAM';
nLayers = 1;
outlen = 10240;
rv = 0;
codedTrBlock = encDL(mod,nLayers,outlen,rv);
%创建和配置 DL-SCH 解码器系统对象。
decDL = nrDLSCHDecoder;
decDL.TargetCodeRate = targetCodeRate;
decDL.TransportBlockLength = trBlkLen;
%在代表编码传输块的软位上调用DL-SCH解码器。使用为编码器指定的配置参数。,输出中的错误标志表示块解码是否有错误。
rxSoftBits = 1.0 - 2.0*double(codedTrBlock);
[decbits,blkerr] = decDL(rxSoftBits,mod,nLayers,rv)
%验证发送和接收的消息位是否相同
isequal(decbits,trBlk)