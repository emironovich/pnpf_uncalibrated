syms u v w x y z;
t = sym('t', [3, 1]);
R = sym('r', 3);
ux = [ 0 -1 w*v;
       1 0 -w*u;
       -v u 0];
P = [R(1:2, :), t(1:2); R(3, :), t(3)];
X = [x;y;z;1];
eqs = ux*P*X;
for i = 1 : 3
    [ct, tt] = coeffs(eqs(i, :), t)
end

