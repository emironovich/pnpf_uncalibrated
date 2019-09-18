function [n, xs, ys, zs] = solve_3Q3(c, e) %c -- 3x10 coefficients matrix
%SOLVE_3Q3 Summary of this function goes here
%   Detailed explanation goes here
    A = find_A(c);
    P = find_P(c);
    P_prime = zeros(3, 3, 3, 'like', c);
    for i = 1 : 3
        P_prime(:, :, i) = A\P(:, :, i);
    end
    M = find_M(P_prime);
    pol = find_det_M(M);
    xs_complex = roots(pol');
    xs = zeros(1, length(xs_complex), 'like', c);
    n = 0;
    for i = 1 : length(xs_complex)
        if abs(imag(xs_complex(i))) < e
            n = n + 1;
            xs(n) = real(xs_complex(i));
        end
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
    d = conv(M(:, 1, 1), find_det2(M(:, 2:3, 2:3))) - ...
        conv(M(:, 1, 2), find_det2(cat(3, M(:, 2:3, 1), M(:, 2:3, 3)))) + ...
        conv(M(:, 1, 3), find_det2(M(:, 2:3, 1:2)));
end

function d = find_det2(M)
    d = conv(M(:, 1, 1), M(:, 2, 2)) - conv(M(:, 1, 2), M(:, 2, 1));
end

