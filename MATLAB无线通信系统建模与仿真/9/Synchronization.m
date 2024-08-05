ssblock = zeros([240 4])

ncellid = 17;
pssSymbols = nrPSS(ncellid)

pssIndices = nrPSSIndices;

imagesc(abs(ssblock));
caxis([0 4]);
axis xy;
xlabel('OFDM符号');
ylabel('副载波');
title('包含PSS的SS/PBCH块');

sssSymbols = nrSSS(ncellid)

sssIndices = nrSSSIndices;
ssblock(sssIndices) = 2 * sssSymbols;

sssSubscripts = nrSSSIndices('IndexStyle','subscript','IndexBase','0based')

imagesc(abs(ssblock));
caxis([0 4]);
axis xy;
xlabel('OFDM 符号');
ylabel('副载波');
title('包含 PSS 和 SSS 的 SS/PBCH 块');

cw = randi([0 1],864,1);

v = 0;
pbchSymbols = nrPBCH(cw,ncellid,v)

pbchIndices = nrPBCHIndices(ncellid);
ssblock(pbchIndices) = 3 * pbchSymbols;

imagesc(abs(ssblock));
caxis([0 4]);
axis xy;
xlabel('OFDM 符号');
ylabel('副载波');
title('包含PSS , SSS和PBCH的SS/PBCH 块');

ibar_SSB = 0;
dmrsSymbols = nrPBCHDMRS(ncellid,ibar_SSB)

dmrsIndices = nrPBCHDMRSIndices(ncellid);
ssblock(dmrsIndices) = 4 * dmrsSymbols;

imagesc(abs(ssblock));
caxis([0 4]);
axis xy;
xlabel('OFDM 符号');
ylabel('副载波');
title('包含PSS、SSS、PBCH和PBCH DM-RS的SS/PBCH块');


nSubframes = 5
symbolsPerSlot = 14
mu = 1;

nSymbols = symbolsPerSlot * 2^mu * nSubframes

n = [0, 1];
firstSymbolIndex = [4; 8; 16; 20] + 28*n;
firstSymbolIndex = firstSymbolIndex(:).'

ssblock = zeros([240 4]);
ssblock(pssIndices) = pssSymbols;
ssblock(sssIndices) = 2 * sssSymbols;

for ssbIndex = 1:length(firstSymbolIndex)
    
    i_SSB = mod(ssbIndex,8);
    ibar_SSB = i_SSB;
    v = i_SSB;
    
    pbchSymbols = nrPBCH(cw,ncellid,v);
    ssblock(pbchIndices) = 3 * pbchSymbols;
    
    dmrsSymbols = nrPBCHDMRS(ncellid,ibar_SSB);
    ssblock(dmrsIndices) = 4 * dmrsSymbols;
    
    ssburst(:,firstSymbolIndex(ssbIndex) + (0:3)) = ssblock;
    
end

imagesc(abs(ssburst));
caxis([0 4]);
axis xy;
xlabel('OFDM 符号');
ylabel('副载波');
title('模式Case B的SS突发');

