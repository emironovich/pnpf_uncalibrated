function F_row = quadruple_constraint(i, j, k, x, y, X, R)
    F_row = zeros(1, 3, 6);
    %fc:
        F_row(1, 1, :) = (y(i) - y(k)) * mult_R(R, 1, X(:, j) - X(:, i)) ...
                        -(x(i) - x(j)) * mult_R(R, 2, X(:, k) - X(:, i));
    %fs:
        F_row(1, 2, :) = -(y(i) - y(k)) * mult_R(R, 2, X(:, j) - X(:, i)) ...
                         -(x(i) - x(j)) * mult_R(R, 1, X(:, k) - X(:, i));
    %1:
        F_row(1, 2, :) = -(y(i) - y(k)) * x(j) * mult_R(R, 3, X(:, j) - X(:, i)) ...
                         +(x(i) - x(j)) * y(k) * mult_R(R, 3, X(:, k) - X(:, i));
end

function sum = mult_R(R, i, X)
    sum = 0;
    for j = 1 : 3
        sum = sum + R(i, j, :) * X(j);
    end
end