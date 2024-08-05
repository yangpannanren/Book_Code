Zout = 132.986;

Fcenter = 400e6;
Bwpass  = 5e6;
if_filter = rffilter('ResponseType','Bandpass',                         ...
    'FilterType','Butterworth','FilterOrder',4,                         ...
    'PassbandAttenuation',10*log10(2),                                  ...
    'Implementation','Transfer function',                               ...
    'PassbandFrequency',[Fcenter-Bwpass/2 Fcenter+Bwpass/2],'Zout',Zout);


freq = linspace(370e6,410e6,2001);
Sf = sparameters(if_filter, freq);
figure;
rfplot(Sf);

freq = linspace(370e6,410e6,2001);
Sf = sparameters(if_filter, freq);
figure;
rfplot(Sf);

gd = groupdelay(if_filter, freq);
figure;
plot(freq/1e6, gd);
xlabel('Frequency, MHz');
ylabel('Group delay');
grid on;


filename = 'filterIF.s2p';
if exist(filename,'file')
    delete(filename)
end
rfwrite(Sf,filename,'format','MA')