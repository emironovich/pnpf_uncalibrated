%this is a test for new function that finds determinant compared to the old
%one
N = 10000;

dts = zeros(2, N);

for i = 1 : N
    M = 10*rand(3, 3, 6);
    start = tic;
    d_new = new_find_det3(M);
    dt_new = toc(start);
    start = tic;
    d_old = find_det3(M);
    dt_old = toc(start);
    
    dts(:, i) = [dt_new, dt_old];
end

disp("Means (new, old):");
disp([mean(dts(1, :)), mean(dts(2, :))]);
disp("Medians (new, old):");
disp([median(dts(1, :)), median(dts(2, :))]);

%this function is copyed from equations_for_groebner.m since it's local
function d = find_det3(M)
    d = mult_poly42(find_det2(M(2:3, 2:3, :)), M(1, 1, :)) - ...
        mult_poly42(find_det2([M(2:3,1,:) M(2:3,3,:)]), M(1, 2, :)) + ...
        mult_poly42(find_det2(M(2:3, 1:2, :)), M(1, 3, :));
end

function d = find_det2(M)
    d = mult_poly22(M(1, 1, :), M(2, 2, :)) - ...
        mult_poly22(M(1, 2, :), M(2, 1, :));
end
