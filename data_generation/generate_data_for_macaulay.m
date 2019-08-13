%this function generates points in space, quaternions for rotation,
%translation and, assuming that focal fistanse is equal to one 
%projects points onto the projection plain

function [X, x, y, qx, qy, T] = generate_data_for_macaulay()
    p = 31991; %modul
    X = mod(ceil(1000000*rand(3, 4)), p); %space points
    
    
    R_q = mod(ceil(1000000*rand(4, 1)), p); %quaternion for rotation
    nw = R_q(1);
    nx = R_q(2);
    ny = R_q(3);
    nz = R_q(4);
    % nw = nz = 0 is bad!!!!
    Rz_q = [nw; 0; 0; nz];
    qx = mod((nw*nx + nz*ny)*powermod((nw^2 + nz^2), p - 2, p), p); 
    qy = mod((nw*ny - nz*nx)*powermod((nw^2 + nz^2), p - 2, p), p);
    Rxy_q = [1; qx; qy; 0];
    
    Rz = mod(quat_to_rot_mod(Rz_q, p), p);
    Rxy = mod(quat_to_rot_mod(Rxy_q, p), p);
    
    T = mod(ceil(1000000*rand(3, 1)), p);
    P = mod([Rz*Rxy, T], p);
    
    p_hom = P*[X;ones(1, 4)];
    x = mod(p_hom(1, :) .* powermod(p_hom(3, :), p - 2, p), p);
    y = mod(p_hom(2, :) .* powermod(p_hom(3, :), p - 2, p), p);
end
