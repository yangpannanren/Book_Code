ckt1 = read(rfckt.passive,'default.s3p');
ckt2 = read(rfckt.amplifier,'default.s2p');
freq = [2e9 2.1e9];
analyze(ckt1,freq);
analyze(ckt2,freq);
sparams_3p = ckt1.AnalyzedResult.S_Parameters;
sparams_2p = ckt2.AnalyzedResult.S_Parameters;
%将两组设备通过一个端口级联。
Kconn = 1;
sparams_cascaded_3p = cascadesparams(sparams_3p,sparams_2p,Kconn)