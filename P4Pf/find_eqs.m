function eqs = find_eqs(ND) %ND = [N; D]
    eqs = zeros(4, 10);
    eqs(1, :) = mult_pp(1, 1, 2, 1, ND) + mult_pp(1, 2, 2, 2, ND) + mult_pp(1, 3, 2, 3, ND);
    eqs(2, :) = mult_pp(3, 1, 1, 1, ND) + mult_pp(3, 2, 1, 2, ND) + mult_pp(3, 3, 1, 3, ND);
    eqs(3, :) = mult_pp(3, 1, 2, 1, ND) + mult_pp(3, 2, 2, 2, ND) + mult_pp(3, 3, 2, 3, ND);
    eqs(4, :) = sq_pp(1, 1, ND) + sq_pp(1, 2, ND) + sq_pp(1, 3, ND) - ...
        sq_pp(2, 1, ND) - sq_pp(2, 2, ND) - sq_pp(2, 3, ND);
end

function prod = mult_pp(i, j, m, k, ND) 
    % we need coeffs for [x^2, y^2, z^2, xy, xz, yz, x, y, z, 1)]
    a = ND(4*(i - 1) + j, :);
    b = ND(4*(m - 1) + k, :);
    prod = [a(1)*b(1), a(2)*b(2), a(3)*b(3), a(1)*b(2) + a(2)*b(1), a(1)*b(3) + a(3)*b(1), a(2)*b(3) + a(3)*b(2), a(1)*b(4) + a(4)*b(1), a(2)*b(4) + a(4)*b(2), a(3)*b(4) + a(4)*b(3), a(4)*b(4)];
    
end

function prod = sq_pp(i, j, ND)
    prod = mult_pp(i, j, i, j, ND);
end