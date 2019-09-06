function c_reorg = reorganize_from_coeff(c, t, pwr, qx, qy)
    if pwr == 2
        sz = 6;
    elseif pwr == 4
        sz = 15;
    elseif pwr == 6
        sz = 28;
    elseif pwr == 8
        sz = 45;
    end
    [mons, ~] = make_monomial_set(pwr, qx, qy);
    
    %reorganizing coefficients
    c_reorg = zeros(sz, 1);
    for i = 1 : sz
        j = find(t == mons(i));
        if ~isempty(j)
            c_reorg(i) = c(j);
        end
    end

end