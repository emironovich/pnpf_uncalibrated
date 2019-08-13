%this function generates points in space, focal distanse, rotation and
%center of the camera and then projects points onto the prjection plain

function [X, x, y, R, C, f, P] = generate_data()
    X = rand(3, 4); %space points
    f = rand();
    
    r_vector = rand(3, 1);
    r_vector_skew = make_skew(r_vector);
    R = expm(r_vector_skew); %rotation
    
    C = rand(3, 1); %camera center
    K = diag([f, f, 1]);
    P = K*R*[eye(3), -C];
    
    p_hom = P*[X;ones(1, 4)];
    x = p_hom(1, :) ./ p_hom(3, :);
    y = p_hom(2, :) ./ p_hom(3, :);
end
