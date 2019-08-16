function M = make_mult_matrix(C)
%this function creates a matrix for multiplication by x in the monomial 
%basis B
%monomial basis B = {x^3, ...., 1} -- monomials up to the 3d degree, #B = 10
    %x^3, x^2*y, x*y^2, y^3, x^2, x*y, y^2, x, y, 1
    M = zeros(10, 10);
    for i = 1 : 4
        M(:, i) = -C(15 + i, :)';
    end
    M(1, 5) = 1;
    M(2, 6) = 1;
    M(3, 7) = 1;
    M(5, 8) = 1;
    M(6, 9) = 1;
    M(8, 10) = 1;
end