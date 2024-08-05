hx = helix
show(hx)
hx = helix('Radius',28e-3,'Width',1.2e-3,'Turns',4)

show(hx)
pattern(hx,1.8e9)
patternAzimuth(hx,1.8e9)
figure
patternElevation(hx,1.8e9)
Directivity = pattern(hx,1.8e9,0,90)

[E,H] = EHfields(hx,1.8e9,[0;0;1])

pattern(hx,1.8e9,'Polarization','RHCP')
[bw, angles] = beamwidth(hx,1.8e9,0,1:1:360)

impedance(hx,1.7e9:1e6:2.2e9)
S = sparameters(hx,1.7e9:1e6:2.2e9,72)

patternAzimuth(hx,1.8e9)

figure
patternElevation(hx,1.8e9)

Directivity = pattern(hx,1.8e9,0,90)

[E,H] = EHfields(hx,1.8e9,[0;0;1])

impedance(hx,1.7e9:1e6:2.2e9)
S = sparameters(hx,1.7e9:1e6:2.2e9,72)

rfplot(S)
returnLoss(hx,1.7e9:1e6:2.2e9,72)
vswr(hx,1.7e9:1e6:2.2e9,72)
charge(hx,2.01e9)
figure
current(hx,2.01e9)
mesh(hx)

mesh(hx,'MaxEdgeLength',0.01)