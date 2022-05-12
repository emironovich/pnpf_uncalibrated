function [y, z] = find_yz(M, x)
    M_subs = zeros(3, 'like', x);
    mons = [x^4, x^3, x^2, x, 1];
    for i = 1 : 3
        for j = 1 : 3
            M_subs(i, j) = mons * M(:, i, j);
        end
    end
    [Q, ~] = qr(M_subs');
    y = Q(1, 3) / Q(3, 3);
    z = Q(2, 3) / Q(3, 3);
end