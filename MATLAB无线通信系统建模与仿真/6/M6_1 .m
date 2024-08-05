load planarmesh.mat;
c = customAntennaMesh(p,t);
show(c)

createFeed(c,[0.07,0.01],[0.05,0.05]);
Z = impedance(c,100e6)