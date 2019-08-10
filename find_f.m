function [fc, fs, n] = find_f(F, x, y, e)
    F_eval = zeros(4, 3);
    mons =  [x^2, x*y, y^2, x, y, 1];
    for i = 1 : 4
        for j = 1 : 3
            for k = 1 : 6
                F_eval(i, j) = F_eval(i, j) + F(i, j, k)*mons(k);
            end
        end
    end
    
    [Q, R] = qr(F_eval');
    if abs(R(2, 2) - 0) < e %rankF = 1
        n = 2;
        fc = [Q(1, 2) / Q(3, 2), Q(1, 2) / Q(3, 2)];
        fs = [Q(2, 2) / Q(3, 2), Q(2, 3) / Q(3, 3)];
    else
        n = 1;
        fc = Q(1, 3) / Q(3, 3);
        fs = Q(2, 3) / Q(3, 3);
    end
end