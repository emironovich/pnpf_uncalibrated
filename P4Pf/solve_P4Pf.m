function [n, fs, Rs, Ts, A, N, D, eqs] = solve_P4Pf(X, u, v, e)
%SOLVE_3Q3 Summary of this function goes here
%       X = [p1, p2, p3, p4], pi = [4, 1]; X(:, i) <-> (u(i), v(i))
    X = [X; ones(1, 4)];
    A = find_A(X, u, v);
    [Q, ~] = qr(A');
    N = Q(:, 5:end); %nullspace
    D = find_D(X, u, v, N, e);
    eqs = find_eqs([N; D]); 
    [n, xs, ys, zs] = solve_3Q3(eqs(1:3, :), e); %we may choes another 3 out of 4 eq-s
    fs = zeros(1, n);
    for i = 1 : n
        P = [N; D]*[xs(i); ys(i); zs(i); 1];
        P = [P(1:4)'; P(5:8)'; P(9:12)'];
        w = sqrt(sum(P(3, 1:3).^2)/sum(P(1, 1:3).^2));
        fs(i) = 1/w;
    end
    Rs = [];
    Ts = [];
    %next we need to find w = 1/f
    %and then we can find R and T
end

function A = find_A(X, u, v)
    %[p11, p12, p13, p14, p21, p22, p23, p24]'
    A = zeros(4, 8);
    for i = 1 : 4
        A(i,  :) = [-v(i)*X(:, i)', u(i)*X(:, i)'];
    end
end

function D = find_D(X, u, v, ns, e)
    B = zeros(4);
    C = zeros(4);
    for i = 1 : 4
        if abs(u(i)) < e
            fctr = v(i);
            offset = 4;
        else
            fctr = u(i);
            offset = 0;
        end
        B(i, :) = fctr*X(:, i)';
        for j = 1 : 4
            C(i, j) = X(:, i)'*ns((1:4)+offset, j);
        end
    end
    D = B\C;
end