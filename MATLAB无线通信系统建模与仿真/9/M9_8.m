carrier = nrCarrierConfig('NSlot',10);

csirs = nrCSIRSConfig;
csirs.CSIRSType = {'nzp','zp'};
csirs.CSIRSPeriod = {[5 1],[5 1]};
csirs.RowNumber = [3 5];
csirs.Density = {'one','one'};
csirs.SymbolLocations = {13,9};
csirs.SubcarrierLocations = {6,4};

[sym,info_sym] = nrCSIRS(carrier,csirs,...
                'OutputResourceFormat','cell')
            
[ind,info_ind] = nrCSIRSIndices(carrier,csirs,...
                'IndexStyle','subscript','OutputResourceFormat','cell')
  