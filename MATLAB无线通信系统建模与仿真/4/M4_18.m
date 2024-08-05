%创建一个有5个符号、3个发射天线和6个窗口长度的OFDM调制器对象。
ofdmMod = comm.OFDMModulator('FFTLength',256, ...
    'NumGuardBandCarriers',[12; 11], ...
    'NumSymbols', 5, ...
    'NumTransmitAntennas', 3, ...
    'PilotInputPort',true, ...
    'Windowing', true, ...
    'WindowLength', 6);
%为第一发射天线指定偶数和奇数符号的导频指数。
pilotIndOdd = [20; 58; 96; 145; 182; 210];
pilotIndEven = [35; 73; 111; 159; 197; 225];
pilotIndicesAnt1 = cat(2, pilotIndOdd, pilotIndEven, pilotIndOdd, ...
    pilotIndEven, pilotIndOdd);
%根据为第一天线指定的指标生成第二和第三天线的导频指标。将三根天线的索引连接起来，并将它们分配到导频载波索引属性。
pilotIndicesAnt2 = pilotIndicesAnt1 + 5;
pilotIndicesAnt3 = pilotIndicesAnt1 - 5;

ofdmMod.PilotCarrierIndices = cat(3, pilotIndicesAnt1, pilotIndicesAnt2, pilotIndicesAnt3);
%在现有OFDM调制器系统对象的基础上，用两个接收天线创建OFDM解调器。使用info函数确定数据和试验尺寸。
ofdmDemod = comm.OFDMDemodulator(ofdmMod);
ofdmDemod.NumReceiveAntennas = 2;

dims = info(ofdmMod)
%给定modDim中指定的阵列大小，为OFDM调制器生成数据和导频符号。
dataIn = complex(randn(dims.DataInputSize), randn(dims.DataInputSize));
pilotIn = complex(randn(dims.PilotInputSize), randn(dims.PilotInputSize));
%将OFDM调制应用于数据和导频。
modOut = ofdmMod(dataIn,pilotIn);

chanGain = complex(randn(3,2), randn(3,2));
chanOut = modOut * chanGain;
%使用OFDM解调器对象解调接收到的数据。
 [dataOut,pilotOut] = ofdmDemod(chanOut);
 %显示三个发射天线的资源映射。图中的灰线显示了为避免天线间的干扰而自定义的空值放置。
showResourceMapping(ofdmMod)
%对于第一发射和第一接收天线对，演示所述输入导频信号与所述输入导频信号匹配。