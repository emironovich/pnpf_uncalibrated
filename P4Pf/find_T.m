function [T, A, b] = find_T(X, u, v, R, w)
    A = zeros(12, 3, 'double');
    b = zeros(12, 1, 'double');
    
    for i = 1 : 4
        A(3*i - 2:3*i, :) = [     0,   -1,  w*v(i);
                                  1,    0, -w*u(i);
                              -v(i), u(i),      0];
        b(3*i - 2:3*i) = -A(3*i - 2:3*i, :)*R*X(:, i);
    end
    T = A\b;
end