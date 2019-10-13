N=100000;

solvers = {@(X,x,y,e)pnpf_mex('p35p_double', X,x,y,e), @(X,x,y,e)pnpf_mex('p35p_single',X,x,y,e), @(X,x,y,e)pnpf_mex('p4pf_double',X,x,y,e), @(X,x,y,e)pnpf_mex('p4pf_single',X,x,y,e)};
dp = [true, false, true, false];
filenames = {'p35p_double', 'p35p_single', 'p4pf_double', 'p4pf_single'};
M = numel(solvers);
assert(numel(dp) == M);
assert(numel(filenames) == M);


% solver_id; dF; dR; dC; nSols; dt
cols={'algo','test-case','dF','dR','dC','nSols','dt'};
S = numel(cols);
stats = nan(S,M,N);

eps_single = eps('single');
eps_double = eps('double');

parfor i=1:N
    F = 0.5+rand(1)*1000;
    K = [F 0 0; 0 F 0; 0 0 1];
    R = rod2dcm(rand(1,3));
    T = rand(3, 1)-0.5;

    P = K * [R T];
    T = -R'*T;

    % XXX: one of rare cases when all algorithms work
    pt_3d = rand(4, 3) * 6 - [3 3 -1];
    pt_3d = pt_3d * R + repmat(T', [4 1]);


    pt_hom = [pt_3d ones(4, 1)] * P';
    pt_2d = pt_hom(:,1:2) ./ repmat(pt_hom(:,3), [1 2]);

    pt_3d_double = pt_3d;
    pt_3d_single = single(pt_3d);

    pt_2d_double = pt_2d;
    pt_2d_single = single(pt_2d);

    for j=1:M
        fun = solvers{j};
        a = tic;
        if dp(j)
            [n,fs,r,t] = fun(pt_3d_double', pt_2d_double(:,1)', pt_2d_double(:,2)', eps_double);
        else
            [n,fs,r,t] = fun(pt_3d_single', pt_2d_single(:,1)', pt_2d_single(:,2)', eps_single);
        end
        b = toc(a);

        if (n == 0)
            stats(:,j,i) = [j; i; nan; nan; nan; 0; b];
            continue;
        end
        [~,bestId] = min(abs(log(F./fs)));
        f=double(fs(bestId));
        r=double(r(:,:,bestId));
        t=double(t(:,bestId));
        df = abs(log(f)-log(F));
        dR = sum((r(:)-R(:)).^2);
        dT = sum((t(:)-T(:)).^2);
        stats(:,j,i) = [j; i; df; dR; dT; double(n); b];
    end
end

data = cell(1,S);
data(1,:) = cols;
for j=1:M
    nrow = size(data, 1);
    data(nrow+(1:N),2:end) = mat2cell(squeeze(stats(2:end,j,:))', repmat(1,[N 1]), repmat(1, [S-1 1]));
    data(nrow+(1:N),1) = {filenames{j}};
end
f = fopen('becnchmark.csv', 'wb');
for j=1:size(data,1)
    format = '%s,%g,%g,%g,%g,%g,%g\n';
    if j == 1
        format = '%s,%s,%s,%s,%s,%s,%s\n';
    end
    fprintf(f,format, data{j,:}); 
end
fclose(f);