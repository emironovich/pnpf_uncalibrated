%find P
syms x y z;
c = sym('c', [3, 10]);
mons = [x^2; y^2; z^2; x*y; x*z; y*z; x; y; z; 1];

eq = c(1, :) * mons;

[cyz, tyz] = coeffs(eq, [y, z]);

%find M

P = sym('p', [3, 3, 3]);

