amp = read(rfckt.amplifier,'samplebjt2.s2p');
[sparams,AllFreq] = extract(amp.AnalyzedResult,'S_Parameters');

[mu,muprime] = stabilitymu(sparams);
figure
plot(AllFreq/1e9,mu,'--',AllFreq/1e9,muprime,'r')
legend('MU','MU\prime','Location','Best') 
title('稳定性参数MU和MU\prime')
xlabel('频率（GHz）')

disp('测量频率，放大器不是无条件稳定:')
fprintf('\t频率 = %.1e\n',AllFreq(mu<=1))

AllGammaL = calculate(amp,'GammaML','none');
AllGammaS = calculate(amp,'GammaMS','none');
hsm = smithplot([AllGammaL{:} AllGammaS{:}]);
hsm.LegendLabels = {'#Gamma ML','#Gamma MS'};

freq = AllFreq(AllFreq == 1.9e9);
GammaL = AllGammaL{1}(AllFreq == 1.9e9)


hsm = smithplot;
circle(amp,freq,'Gamma',abs(GammaL),hsm); 
hsm.GridType = 'yz';
hold all
plot(0,0,'k.','MarkerSize',16)                    
plot(GammaL,'k.','MarkerSize',16)
txtstr = sprintf('\\Gamma_{L}\\fontsize{8}\\bf=\\mid%s\\mid%s^\\circ', ...
    num2str(abs(GammaL),4),num2str((angle(GammaL)*180/pi),4));
text(real(GammaL),imag(GammaL)+.1,txtstr,'FontSize',10, ...
    'FontUnits','normalized');
plot(0,0,'r',0,0,'k.','LineWidth',2,'MarkerSize',16);
text(0.05,0,'y_L','FontSize',12,'FontUnits','normalized')


 circle(amp,freq,'G',1,hsm);      
hsm.ColorOrder(2,:) = [1 0 0];
[~,pt2] = imped_match_find_circle_intersections_helper([0 0], ...
    abs(GammaL),[-.5 0],.5);
GammaMagA = sqrt(pt2(1)^2 + pt2(2)^2);  
GammaAngA = atan2(pt2(2),pt2(1));       
plot(pt2(1),pt2(2),'k.','MarkerSize',16);
txtstr = sprintf('A=\\mid%s\\mid%s^\\circ',num2str(GammaMagA,4), ...
    num2str(GammaAngA*180/pi,4));
text(pt2(1),pt2(2)-.07,txtstr,'FontSize',8,'FontUnits','normalized', ...
    'FontWeight','Bold')
annotation('textbox','VerticalAlignment','middle',...
    'String',{'单位','电导','圆'},...
    'HorizontalAlignment','center','FontSize',8,...
    'EdgeColor',[0.04314 0.5176 0.7804],...
    'BackgroundColor',[1 1 1],'Position',[0.1403 0.1608 0.1472 0.1396])
annotation('arrow',[0.2786 0.3286],[0.2778 0.3310])
annotation('textbox','VerticalAlignment','middle',...
    'String',{'常数','幅值','圆'},...
    'HorizontalAlignment','center','FontSize',8,...
    'EdgeColor',[0.04314 0.5176 0.7804],...
    'BackgroundColor',[1 1 1],'Position',[0.8107 0.3355 0.1286 0.1454])
annotation('arrow',[0.8179 0.5761],[0.4301 0.4887]);
hold off


StubPositionOut = ((2*pi + GammaAngA) - angle(GammaL))/(4*pi)

GammaA = GammaMagA*exp(1j*GammaAngA);
bA = imag((1 - GammaA)/(1 + GammaA));
StubLengthOut = -atan2(-2*bA/(1 + bA^2),(1 - bA^2)/(1 + bA^2))/(4*pi)

GammaS = AllGammaS{1}(AllFreq == 1.9e9)

[pt1,pt2] = imped_match_find_circle_intersections_helper([0 0], ...
    abs(GammaS),[-.5 0],.5);
GammaMagA = sqrt(pt2(1)^2 + pt2(2)^2);
GammaAngA = atan2(pt2(2),pt2(1));
GammaA = GammaMagA*exp(1j*GammaAngA);
bA = imag((1 - GammaA)/(1 + GammaA));
StubPositionIn = ((2*pi + GammaAngA) - angle(GammaS))/(4*pi)

StubLengthIn = -atan2(-2*bA/(1 + bA^2),(1 - bA^2)/(1 + bA^2))/(4*pi)

stubTL4 = rfckt.microstrip;
analyze(stubTL4,freq);
Z0 = stubTL4.Z0;


phase_vel = stubTL4.PV;

stubTL1 = rfckt.microstrip('LineLength',phase_vel/freq*StubLengthIn, ...
    'StubMode','shunt','Termination','open');
set(stubTL4,'LineLength',phase_vel/freq*StubLengthOut, ...
    'StubMode','shunt','Termination','open')


matched_amp = rfckt.cascade('Ckts',{stubTL1,TL2,amp,TL3,stubTL4});
analyze(matched_amp,1.5e9:1e7:2.3e9);
analyze(amp,1.5e9:1e7:2.3e9);


clf
plot(amp,'S11','dB')
hold all
hline = plot(matched_amp,'S11','dB');
hline.Color = 'r';
legend('S_{11} - 原始的放大器', 'S_{11} - 匹配的放大器')
legend('Location','SouthEast')
hold off


plot(amp,'S22','dB')
hold all
hline = plot(matched_amp,'S22','dB');
hline.Color = 'r';
legend('S_{22} - 原始的放大器', 'S_{22} - 匹配的放大器')
legend('Location','SouthEast')
hold off

hlines = plot(matched_amp,'Gt','Gmag','dB');
hlines(2).Color = 'r';