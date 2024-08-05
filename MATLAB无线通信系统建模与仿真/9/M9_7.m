carrier = nrCarrierConfig('NSlot',10);
%创建物理下行链路共享信道(PDSCH)配置对象pdsch，其中物理资源块(PRB)从0到30分配。
pdsch = nrPDSCHConfig;
pdsch.PRBSet = 0:30;
%创建具有指定属性的PDSCH解调参考信号(DM-RS)对象dmrs。
dmrs = nrPDSCHDMRSConfig;
dmrs.DMRSConfigurationType = 2;
dmrs.DMRSLength = 2;
dmrs.DMRSAdditionalPosition = 1;
dmrs.DMRSTypeAPosition = 2;
dmrs.DMRSPortSet = 5;
dmrs.NIDNSCID = 10;
dmrs.NSCID = 0;
%将PDSCH DM-RS配置对象分配给PDSCH配置对象的DMRS属性。
pdsch.DMRS = dmrs;
%为指定的载波、PDSCH 配置和输出格式名称-值对参数生成PDSCH DM-RS符号和索引。
sym = nrPDSCHDMRS(carrier,pdsch,'OutputDataType','single')

sym = nrPDSCHDMRS(carrier,pdsch,'OutputDataType','single')

ind = nrPDSCHDMRSIndices(carrier,pdsch,'IndexBase','0based','IndexOrientation','carrier')

grid = complex(zeros([carrier.NSizeGrid*12 carrier.SymbolsPerSlot pdsch.NumLayers]));
grid(ind+1) = sym;
imagesc(abs(grid(:,:,1)));
axis xy;
xlabel('OFDM符号');
ylabel('副载波');
title('载波资源网格中的 PDSCH DM-RS 资源元素');