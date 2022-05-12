function [n, xs, ys, zs] = solve_3Q3(c, e) %c -- 3x10 coefficients matrix
%SOLVE_3Q3 Summary of this function goes here
%   Detailed explanation goes here
    xs = zeros(1, 0, 'like', c);
    coder.varsize('xs', [1 13], [0 1]);
    ys = zeros(1, 0, 'like', c);
    coder.varsize('ys', [1 13], [0 1]);
    zs = zeros(1, 0, 'like', c);
    coder.varsize('zs', [1 13], [0 1]);

    A = find_A(c);
    if rcond(A) < eps
         n = 0;
         return;
    end
    P = find_P(c);
    P_prime = zeros(3, 3, 3, 'like', c);
    for i = 1 : 3
        P_prime(:, :, i) = A\P(:, :, i);
    end
    M = find_M(P_prime);
    pol = find_det_M(M);
    assert(numel(pol)==9);
    if ~isfinite(pol)
        n = 0;
        return;
    end

    xs_complex = roots(pol');
    xs = zeros(1, length(xs_complex), 'like', c);
    n = 0;

    for i = 1 : length(xs_complex)
        n = n + 1;
        xs(n) = real(xs_complex(i));
    end

    xs = xs(1:n);
    ys = zeros(1, n, 'like', c);
    zs = zeros(1, n, 'like', c);
    for i = 1 : n
        [ys(i), zs(i)] = find_yz(M, xs(i));
    end
end

function A = find_A(c)
    A = [c(1, 2), c(1, 3), c(1, 6);
         c(2, 2), c(2, 3), c(2, 6);
         c(3, 2), c(3, 3), c(3, 6)];
end

function P = find_P(c)
    P = zeros(3, 3, 3, 'like', c); %[x^2, x, 1]
    for i = 1 : 3
        P(i, 1, :) = [0, -c(i, 4), -c(i, 8)];        %y
        P(i, 2, :) = [0, -c(i, 5), -c(i, 9)];        %z
        P(i, 3, :) = [-c(i, 1), -c(i, 7), -c(i, 10)]; %1
    end
end

function d = find_det_M(M)
    d = conv(M(2:5, 3, 1), find_det23(M(:, 1:2, 2:3))) - ...
         conv(M(2:5, 3, 2), find_det23(cat(3, M(:, 1:2, 1), M(:, 1:2, 3)))) + ...
         conv(M(:, 3, 3), find_det22(M(:, 1:2, 1:2))); 
end

function d = find_det22(M)
    d = conv(M(3:5, 1, 1), M(3:5, 2, 2)) - conv(M(3:5, 1, 2), M(3:5, 2, 1));
end

function d = find_det23(M)
    d = conv(M(3:5, 1, 1), M(2:5, 2, 2)) - conv(M(2:5, 1, 2), M(3:5, 2, 1));
end

