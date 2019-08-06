function R = init_R()
    R = zeros(3,3,6); %3x3 matrix with 2 degree polynomials in qx>qy
    %coefficients are listed in grevlex order: 1)qx^2, 2)qxqy, 3)qy^2, 4)qx, 5)qy, 6)1

    %1 + qx^2 - qy^2
    R(1, 1, 1) = 1;
    R(1, 1, 3) = -1;
    R(1, 1, 6) = 1;
    %2qxqy
    R(1, 2, 2) = 2;
    %2qy
    R(1, 3, 5) = 2;
    
    %2qxqy
    R(2, 1, 2) = 2;
    %qy^2 - qx^2 + 1 
    R(2, 2, 1) = -1;
    R(2, 2, 3) = 1;
    R(2, 2, 6) = 1;
    %-2qx
    R(2, 3, 4) = -2;
    
    %-2qy
    R(3, 1, 5) = -2;
    %2qx
    R(3, 2, 4) = 2;
    %1 - qx^2 - qy^2
    R(3, 3, 1) = -1;
    R(3, 3, 3) = -1;
    R(3, 3, 6) = 1;    
end