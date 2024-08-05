M = 2;
tblen =  10; 
nsamp = 2;
msgLen = 1000;
const = pammod([0:M-1],M);
msgData = randi([0 M-1],msgLen,1); 
msgSym = pammod(msgData,M);
msgSymUp = upsample(msgSym,nsamp); 
chanest = [0.986; 0.845; 0.237; 0.12345+0.31i]; 
msgFilt = filter(chanest,1,msgSymUp); 
msgRx = awgn(msgFilt,5,'measured');
eqSym = mlseeq(msgRx,chanest,const,tblen,'rst',nsamp);
eqMsg = pamdemod(eqSym,M);

[nerrs ber] = biterr(msgData, eqMsg)

