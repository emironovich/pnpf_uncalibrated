function G = equations_for_groebner(F)
    G = zeros(4, 1, 28);
    G(1, 1, :) = find_det3(F(2:4, :, :)); 
    G(2, 1, :) = find_det3([F(1, :, :); F(3:4, :, :)]);
    G(2, 1, :) = find_det3([F(1:2, :, :); F(4, :, :)]);
    G(4, 1, :) = find_det3(F(1:3, :, :));
    G = squeeze(G);
end

function d = find_det3(M)
    d = mult_poly42(find_det2(M(2:3, 2:3, :)), M(1, 1, :)) - ...
        mult_poly42(find_det2([M(2:3,1,:) M(2:3,3,:)]), M(1, 2, :)) + ...
        mult_poly42(find_det2(M(2:3, 1:2, :)), M(1, 3, :));
end

function d = find_det2(M)
    d = mult_poly22(M(1, 1, :), M(2, 2, :)) - ...
        mult_poly22(M(1, 2, :), M(2, 1, :));
end
