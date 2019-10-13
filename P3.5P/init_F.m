function F = init_F(x, y, X, R)
    F = zeros(4, 3, 6, 'like', x);
    F(1, :, :) = quadruple_constraint(1, 2, 3, x, y, X, R);
    F(2, :, :) = quadruple_constraint(1, 3, 2, x, y, X, R);
    F(3, :, :) = quadruple_constraint(2, 4, 3, x, y, X, R);
    F(4, :, :) = quadruple_constraint(3, 4, 2, x, y, X, R);
end