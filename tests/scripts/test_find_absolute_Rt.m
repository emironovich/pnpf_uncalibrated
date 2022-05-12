% test find_absolute_Rt
% result = runtests('test_find_absolute_Rt');

n = 50; % cameras number
e = 1e-10;

R_gt = zeros(3, 3, n);
t_gt = zeros(3, n);

R_sfm = zeros(3, 3, n);
t_sfm = zeros(3, n);

R_abs = generate_rotation();
t_abs = rand(3,1) - 0.5;
alpha = rand();

for i = 1 : n
    R_gt(:,:,i) = generate_rotation();
    R_sfm(:,:,i) = squeeze(R_gt(:,:,i))*R_abs';
    
    t_gt(:,i) = rand() - 0.5;
    t_sfm(:, i) = squeeze(R_sfm(:,:,i))*(alpha*R_abs*squeeze(R_gt(:,:,i))'*t_gt(:,i) - t_abs);
end

images_gt = containers.Map('KeyType', 'int64', 'ValueType', 'any');
images_sfm = containers.Map('KeyType', 'int64', 'ValueType', 'any');

for i = 1 : n
   images_gt(i) = struct('R', squeeze(R_gt(:,:,i)), 't', t_gt(:, i));
   images_sfm(i) = struct('R', squeeze(R_sfm(:,:,i)), 't', t_sfm(:, i));
end

[R_found, t_found, alpha_found, resnorm_R, resnorm_t] = find_absolute_Rt(images_gt, images_sfm);

%% Test 1: rotation

assert(norm(R_found - R_abs, 'fro') / 3 < e);

%% Test 2: scale

assert(abs((alpha_found - alpha) / alpha) < e);

%% Test 3: translation

assert(norm(t_found - t_abs) / norm(t_abs) < e);

%% Test 4: resnorms

assert(sqrt(resnorm_R/n) < e);
assert(resnorm_t < e);




