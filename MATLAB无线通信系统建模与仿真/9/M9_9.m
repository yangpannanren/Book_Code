carrier = nrCarrierConfig;
%创建一个默认的 PDSCH 配置对象，然后启用 PT-RS 配置。
pdsch = nrPDSCHConfig;
pdsch.EnablePTRS = 1;
%创建具有指定属性的 PDSCH 相位跟踪参考信号 (PT-RS) 配置对象。
ptrs = nrPDSCHPTRSConfig;
ptrs.TimeDensity = 2;
ptrs.FrequencyDensity = 4;
ptrs.REOffset = '10';
%将 PDSCH PT-RS 配置对象分配给 PDSCH 配置对象的 PTRS 属性。
pdsch.PTRS = ptrs;
%生成单一的PDSCH PT-RS 符号数据类型 。
sym = nrPDSCHPTRS(carrier,pdsch,'OutputDataType','single')
%以下标形式生成 PDSCH PTRS 索引，并将索引方向设置为带宽部分。
ind = nrPDSCHPTRSIndices(carrier,pdsch,'IndexStyle','subscript','IndexOrientation','bwp')