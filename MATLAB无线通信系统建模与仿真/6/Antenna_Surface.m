mydipole = dipole('Length',15e-2, 'Width', 5e-3);
show(mydipole);

c = 2.99792458e8;
f = c/(2*mydipole.Length);
current(mydipole, f);
view(90,0);

[C, points]  = current(mydipole, f);
Jy = abs(C(2,:));
Jz = abs(C(3,:));
figure;
plot(points(3,:), Jz, 'r*', points(3,:), Jy, 'b*');
grid on;
xlabel('偶极子的长度(m)')
ylabel('表面电流密度, A/m');
legend('|Jz|', '|Jy|');

myreflector = reflector('Exciter', mydipole, 'Spacing', 0.02);
myreflector.Exciter.Tilt = 90;
myreflector.Exciter.TiltAxis = [0 1 0];
current(myreflector, f);