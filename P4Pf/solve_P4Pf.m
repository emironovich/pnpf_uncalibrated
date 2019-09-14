function [n, fs, Rs, Ts] = solve_P4Pf(X, u, v, e)
%SOLVE_P4Pf Summary of this function goes here
%       X = [p1, p2, p3, p4], pi = [4, 1]; X(:, i) <-> (u(i), v(i))
%       if f is a correct foal length, then [R, T] = [R, T] / sign(d)*abs(d)^(1/3);
%       where d = det(R)
    X = [X; ones(1, 4)];
    A = find_A(X, u, v);
    [Q, ~] = qr(A');
    N = Q(:, 5:end); %nullspace
    D = find_D(X, u, v, N, e);
    eqs = find_eqs([N; D]); 
    [n, xs, ys, zs] = solve_3Q3(eqs(1:3, :), e); %we may choes another 3 out of 4 eq-s
    fs = zeros(1, n);
%    coder.varsize('f_sol', [1 10], [0 1]); %????????????
    Rs = zeros(3, 3, n);
%    coder.varsize('R_sol', [3 3 10], [0 0 1]);%????????????
    Ts = zeros(3, n);
%    coder.varsize('T_sol', [3 10], [0 1]); %?????????
    for i = 1 : n
        P1 = (N(1:3, :)*[xs(i); ys(i); zs(i); 1])';
        P3 = (D(1:3, :)*[xs(i); ys(i); zs(i); 1])';
        
        w = sqrt(sum(P3(1:3).^2)/sum(P1(1:3).^2));
        fs(i) = 1/w;
        
        alpha = norm(P1);
        R1 = P1/alpha;
        R3 = P3/(w*alpha);
        R2 = -cross(R1, R3);
        %R2 = -R2/norm(R2);
        R = [R1; R2; R3];
        Rs(:, :, i) = R;

        Ts(:, i) = find_T(X(1:3, :), u, v, R, w);
    end
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