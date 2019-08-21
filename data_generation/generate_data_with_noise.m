%this function generates points in space, focal distanse, rotation and
%center of the camera and then projects points onto the prjection plain
%then adds gaussian noise

function [X, x, y, R, C, f, P] = generate_data_with_noise(f, d)
    X = repmat([0;0;6], [1, 4]) + 4*(rand(3, 4)-0.5); %space points
    %f = 200+1800*rand();
    
    r_vector = rand(3, 1)-0.5;
    r_vector_skew = make_skew(r_vector);
    R = expm(r_vector_skew); %rotation
    
    C = rand(3, 1)-0.5; %camera center
    K = diag([f, f, 1]);
    P = K*R*[eye(3), -C];
    
    X = R'*X+repmat(C, [1, 4]);
    
    p_hom = P*[X;ones(1, 4)];
    x = p_hom(1, :) ./ p_hom(3, :) + random('Normal', 0, d, [1, 4]);
    y = p_hom(2, :) ./ p_hom(3, :) + random('Normal', 0, d, [1, 4]);
end
