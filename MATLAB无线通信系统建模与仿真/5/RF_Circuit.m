FirstCkt = rfckt.txline;
SecondCkt = rfckt.amplifier('IntpType','cubic');
read(SecondCkt,'default.amp');
ThirdCkt = rfckt.txline('LineLength',0.025,'PV',2.0e8);

PropertiesOfFirstCkt = get(FirstCkt)
PropertiesOfSecondCkt = get(SecondCkt)
PropertiesOfThirdCkt = get(ThirdCkt)

MethodsOfThirdCkt = methods(ThirdCkt);

DefaultLength = FirstCkt.LineLength;

FirstCkt.LineLength = .001;
NewLength = FirstCkt.LineLength;

figure
smithplot(SecondCkt,[1 1;2 2]);

plot(SecondCkt,'Pout','dBm')

f = SecondCkt.AnalyzedResult.Freq;
data = SecondCkt.AnalyzedResult

analyze(SecondCkt,1.85e9:1e7:2.55e9);
smithplot(SecondCkt,[1 1;2 2],'GridType','ZY');

CascadedCkt = rfckt.cascade('Ckts',{FirstCkt,SecondCkt,ThirdCkt});
analyze(CascadedCkt,f);

smithplot(CascadedCkt,[1 1;2 2],'GridType','Z');

plot(CascadedCkt,'S21','dB')

plot(CascadedCkt,'budget','S21','NF')
