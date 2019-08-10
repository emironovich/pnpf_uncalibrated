function S = make_skew(a) 
    S = zeros(3);
    S(1,2) = -a(3);
    S(1,3) = a(2);
    S(2,3) = -a(1);
    
    S(2,1) = a(3);
    S(3, 1) = -a(2);
    S(3,2) = a(1);
end

