samplingFrequency = 2000;
centerFrequency = 450;
transitionWidth = 100;
passbandRipple = 1;
stopbandAttenuation = 80;

designSpec = fdesign.lowpass('Fp,Fst,Ap,Ast',...
    centerFrequency-transitionWidth/2, ...
    centerFrequency+transitionWidth/2, ...
    passbandRipple,stopbandAttenuation, ...
    samplingFrequency);
LPF = design(designSpec,'equiripple','SystemObject',true)

fvtool(LPF)

rng default
inputWordLength = 16;
fixedPointInput = fi(randn(100,1),true,inputWordLength);
floatingPointInput = double(fixedPointInput);
floatingPointOutput = LPF(floatingPointInput);

release(LPF)
fullPrecisionOutput = LPF(fixedPointInput);
norm(floatingPointOutput-double(fullPrecisionOutput),'inf')

LPF.CoefficientsDataType

fvtool(LPF)

measure(LPF)

LPF24bitCoeff = design(designSpec,'equiripple','SystemObject',true);
LPF24bitCoeff.CoefficientsDataType = 'Custom';
coeffNumerictype = numerictype(fi(LPF24bitCoeff.Numerator,true,24));
LPF24bitCoeff.CustomCoefficientsDataType = numerictype(true, ...
            coeffNumerictype.WordLength,coeffNumerictype.FractionLength);
fullPrecisionOutput32bitCoeff = LPF24bitCoeff(fixedPointInput);
norm(floatingPointOutput-double(fullPrecisionOutput32bitCoeff),'inf')

fvtool(LPF24bitCoeff)

measure(LPF24bitCoeff)

LPF14bitCoeff = design(designSpec,'equiripple','SystemObject',true);
coeffNumerictype = numerictype(fi(LPF14bitCoeff.Numerator,true,14));
LPF14bitCoeff.CoefficientsDataType = 'Custom';
LPF14bitCoeff.CustomCoefficientsDataType = numerictype(true, ...
            coeffNumerictype.WordLength,coeffNumerictype.FractionLength);
measure(LPF14bitCoeff,'Arithmetic','fixed')

designSpec.Astop = 60;   
LPF60dBStopband = design(designSpec,'equiripple','SystemObject',true);
LPF60dBStopband.CoefficientsDataType = 'Custom';
coeffNumerictype = numerictype(fi(LPF60dBStopband.Numerator,true,14));
LPF60dBStopband.CustomCoefficientsDataType = numerictype(true, ...
            coeffNumerictype.WordLength,coeffNumerictype.FractionLength);
measure(LPF60dBStopband,'Arithmetic','fixed')

order(LPF14bitCoeff)

designSpec.Astop = 80;    
transitionWidth = 200;
designSpec.Fpass = centerFrequency-transitionWidth/2;
designSpec.Fstop = centerFrequency+transitionWidth/2;
LPF300TransitionWidth = design(designSpec,'equiripple', ...
                               'SystemObject',true);
LPF300TransitionWidth.CoefficientsDataType = 'Custom';
coeffNumerictype = numerictype(fi(LPF300TransitionWidth.Numerator, ...
                                  true, 14));
LPF300TransitionWidth.CustomCoefficientsDataType = numerictype(true, ...
            coeffNumerictype.WordLength,coeffNumerictype.FractionLength);
measure(LPF300TransitionWidth,'Arithmetic','fixed')