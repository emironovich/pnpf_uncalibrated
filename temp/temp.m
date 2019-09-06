%ordering monomials in grevlex
cnt = 1;
sz = 45; %4 -- 15, 6 -- 28, 8 -- 45
arr = zeros(sz, 2);

for d = 0 : 8
    for i = 0 : d
        j = d - i;
        arr(cnt, :) = [i, j];
        cnt = cnt + 1;
    end
end

for i = 1 : sz
    for j = 1 : sz - 1
        sum1 = arr(j, 1) + arr(j, 2);
        sum2 = arr(j + 1, 1) + arr(j + 1, 2);
        diff = arr(j, :) - arr(j + 1, :);
        if diff(2) == 0
            if(diff(1) < 0)
                flag = true;
            else
                flag = false;
            end
        elseif diff(2) < 0
            flag = true;
        else
            flag = false;
        end
        
        if not((sum1 > sum2) || (sum1 == sum2 && flag))
            t = arr(j, :);
            arr(j, :) = arr(j + 1, :);
            arr(j + 1, :) = t;
        end        
    end
end

syms x y;
mons = sym('m', [sz, 1]);
for i = 1 : sz
    mons(i) = x^arr(i, 1)*y^arr(i, 2);
end

%making a function that multiplies 2 degree polynomials

syms a1 a2 a3 a4 a5 a6;
syms b1 b2 b3 b4 b5 b6;
p1 = a1*x^2 + a2*x*y + a3*y^2 + a4*x + a5*y + a6;
p2 = b1*x^2 + b2*x*y + b3*y^2 + b4*x + b5*y + b6;
p = p1 * p2;

[cxy, txy] = coeffs(p, [x,y]);

%testing that function
c1 = [1 2 3 4 5 6];
c2 = [13 14 15 16 17 18];

p1eval = subs(p1, [a1 a2 a3 a4 a5 a6], c1);
p2eval = subs(p2, [b1 b2 b3 b4 b5 b6], c2);

[cxyeval, txyeval] = coeffs(p1eval*p2eval, [x,y]);

%making a function that multiplies 4 degree polynomial by 2 degree
%polynomial
syms d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15;

q = [d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15]*mons((sz-14):sz);
p1 = a1*x^2 + a2*x*y + a3*y^2 + a4*x + a5*y + a6;

[cxy2, txy2] = coeffs(q*p1, [x,y]);

cfs = sym('c', [1, 28]);
for i = 1 : 28
    j = find(txy2 == mons(i));
    cfs(i) = cxy2(j);
end

c3 = 1 : 15;
c4 = 21 : 26;

qeval = c3*mons((sz-14):sz);
p1eval = subs(p1, [a1 a2 a3 a4 a5 a6], c4);
