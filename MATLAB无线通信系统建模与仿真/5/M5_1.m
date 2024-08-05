hR1 = resistor(50,'R50');
hckt1 = circuit('example2');
add(hckt1,[1 2],hR1)
setports (hckt1, [1 0],[2 0])
freq = linspace (1e3,2e3,100);
S = sparameters(hckt1,freq,100);
disp(S)