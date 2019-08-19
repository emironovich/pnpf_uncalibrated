function [X, x, y, fc, fs, qx, qy, T, P] = generate_data_with_new_parametrization()
    X = rand(3, 4)*100; %four 3d points
    R_q = rand(4, 1); %quaternion for rotation
    nw = R_q(1);
    nx = R_q(2);
    ny = R_q(3);
    nz = R_q(4);
    Rz_q = [nw; 0; 0; nz];
    qx = (nw*nx + nz*ny)/(nw^2 + nz^2); 
    qy = (nw*ny - nz*nx)/(nw^2 + nz^2);
    Rxy_q = [1; qx; qy; 0];
    
    Rz = quat_to_rot(Rz_q);
    Rxy = quat_to_rot(Rxy_q);
    
    T = rand(3, 1)*100; %translation
    f = rand(); %focal distance
    
    fc = f*Rz(1, 1);
    fs = f*Rz(2, 1);
    
    K = diag([f, f, 1]);
    P = [K*Rz*Rxy, T];
    
    p_hom = P*[X;ones(1, 4)];
    x = p_hom(1, :) ./ p_hom(3, :);
    y = p_hom(2, :) ./ p_hom(3, :);
    
end