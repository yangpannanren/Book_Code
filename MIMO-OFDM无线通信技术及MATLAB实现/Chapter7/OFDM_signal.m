% OFDM_signal.m
clear; close all; clc;
N=8;
b=2;
M=2^b;
Nos=16;
NNos=N*Nos;
T=1/NNos;
time = 0:T:1-T;
[X,Mod] = mapper(b,N);
X(1)=0+1i*0; %symbols with no DC-subcarrier
for i = 1:N
    if i<=N/2
        x = ifft([zeros(1,i-1) X(i) zeros(1,NNos-i+1)],NNos);
    else
        x = ifft([zeros(1,NNos-N+i-1) X(i) zeros(1,N-i)],NNos);
    end
    xI(i,:) = real(x);
    xQ(i,:) = imag(x);
end
sum_xI = sum(xI);
sum_xQ = sum(xQ);
figure(1), clf
subplot(311)
plot(time,xI,'k:','linewidth',1), hold on
plot(time,sum_xI,'b','linewidth',2)
title([Mod ', N=' num2str(N)]);
ylabel('x_{I}(t)');
axis([0 1 min(sum_xI) max(sum_xI)]);
subplot(312)
plot(time,xQ,'k:','linewidth',1); hold on
plot(time,sum_xQ,'b','linewidth',2)
ylabel('x_{Q}(t)');
axis([0 1 min(sum_xQ) max(sum_xQ)]);
subplot(313)
plot(time,abs(sum_xI+1i*sum_xQ),'b','linewidth',2), hold on
ylabel('|x(t)|'); xlabel('t');
clear('xI'), clear('xQ')
N=2^4;
NNos=N*Nos;
T=1/NNos;
time=0:T:1-T;
Nhist=1e3;
N_bin = 30;
for k = 1:Nhist
    [X,Mod] = mapper(b,N);
    X(1)=0+1i*0; %symbols with no DC-subcarrier
    for i = 1:N
        if (i<= N/2)
            x = ifft([zeros(1,i-1) X(i) zeros(1,NNos-i+1)],NNos);
        else
            x = ifft([zeros(1,NNos-N/2+i-N/2-1) X(i) zeros(1,N-i)],NNos);
        end
        xI(i,:) = real(x);
        xQ(i,:) = imag(x);
    end
    HistI(NNos*(k-1)+1:NNos*k) = sum(xI);
    HistQ(NNos*(k-1)+1:NNos*k) = sum(xQ);
end
figure(2), clf
subplot(311)
histogram(HistI,N_bin,'Normalization','probability');
title([Mod ', N=' num2str(N)]);
ylabel('pdf of x_{I}(t)');
subplot(312)
histogram(HistQ,N_bin,'Normalization','probability');
ylabel('pdf of x_{Q}(t)');
subplot(313)
histogram(abs(HistI+1i*HistI),N_bin,'Normalization','probability');
ylabel('pdf of |x(t)|');
xlabel('x_{0}');