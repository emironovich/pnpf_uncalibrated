%this function generates points in space, focal distanse, rotation and
%center of the camera and then projects points onto the prjection plain
%then adds gaussian noise with zero mean and standard deviation d
%d = 0 if the argument is not provided
function [X, x, y, R, C, f, P] = generate_data(d)
    if nargin == 0
        d = 0;
    end
    
    X = repmat([0;0;6], [1, 4]) + 4*(rand(3, 4)-0.5); %space points
    f = 200+1800*rand();
    
    r_vector = rand(3, 1)-0.5;
    r_vector_skew = make_skew(r_vector);
    R = expm(r_vector_skew); %rotation
    
    C = rand(3, 1)-0.5; %camera center
    K = diag([f, f, 1]);
    P = K*R*[eye(3), -C];
    
    X = R'*X+repmat(C, [1, 4]);
    
    p_hom = P*[X;ones(1, 4)];
    xy = p_hom(1:2, :) ./ p_hom(3, :) + normrnd(0, d, [2, 4]);
    x = xy(1, :); 
    y = xy(2, :);
end
