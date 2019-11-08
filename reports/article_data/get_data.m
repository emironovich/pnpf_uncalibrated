%script that provides data
N=10000;

solvers = {@(X,x,y,e)pnpf_mex('p35pf_double', X,x,y,e), @(X,x,y,e)pnpf_mex('p35pf_single',X,x,y,e), @(X,x,y,e)pnpf_mex('p4pf_double',X,x,y,e), @(X,x,y,e)pnpf_mex('p4pf_single',X,x,y,e)};
dp = [true, false, true, false];
algonames = {'p35pf_double', 'p35pf_single', 'p4pf_double', 'p4pf_single'};
M = numel(solvers);
assert(numel(dp) == M);
assert(numel(algonames) == M);

data_generators = {@()generate_data_p35p_style(), @()generate_data_p4p_style()};
file_names = {'p35p_data.csv', 'p4p_data.csv'};
K = numel(data_generators);
assert(numel(file_names) == K);

stats = nan(N, M);

eps_single = eps('single');
eps_double = eps('double');

for l=1:K
    for i=1:N
        gen = data_generators{l};
        [pt_3d, x, y, F, R, T, P] = gen();
        pt_2d = [x; y];

        pt_3d_double = pt_3d';
        pt_3d_single = single(pt_3d');

        pt_2d_double = pt_2d';
        pt_2d_single = single(pt_2d');

        for j=1:M
            fun = solvers{j};

            if dp(j)
                [n,fs,r,t] = fun(pt_3d_double', pt_2d_double(:,1)', pt_2d_double(:,2)', eps_double);
            else
                [n,fs,r,t] = fun(pt_3d_single', pt_2d_single(:,1)', pt_2d_single(:,2)', eps_single);
            end

            [~,bestId] = min(abs(log(F./fs)));
            f=double(fs(bestId));
            df = abs((f - F)/F);
            if n ~= 0
                stats(i, j) = df;
            end
        end
    end
    f = fopen(file_names{l}, 'wb');
    fprintf(f, 'algorithm,df\n');
    for j=1:M
        for i = 1:N
            fprintf(f, '%s,%g\n', algonames{j}, stats(i, j));
        end
    end
    fclose(f);
end

data_generators = {@(d, f)generate_data_p35p_style(d, f), @(d, f)generate_data_p4p_style(d, f)};
file_names = {'p35p_data_noisy.csv', 'p4p_data_noisy.csv'};
f_in = [200, 1.7];
K = numel(data_generators);
assert(numel(file_names) == K);
assert(numel(f_in) == K);

noise_level = {0:0.5:5, [0, 0.01, 0.1, 0.5, 1]};
assert(numel(noise_level) == K);

for l = 1 : K
    stats = nan(N*numel(noise_level{l}), 2, M);
    ind  = 1;
    for k = 1 : numel(noise_level{l})
        for i = 1 : N
            gen = data_generators{l};
            [pt_3d, x, y, F, R, T, P] = gen(noise_level{l}(k), f_in(l));
            pt_2d = [x; y];

            pt_3d_double = pt_3d';
            pt_3d_single = single(pt_3d');

            pt_2d_double = pt_2d';
            pt_2d_single = single(pt_2d');
            for j = 1 : M
                fun = solvers{j};

                if dp(j)
                    [n,fs,r,t] = fun(pt_3d_double', pt_2d_double(:,1)', pt_2d_double(:,2)', eps_double);
                else
                    [n,fs,r,t] = fun(pt_3d_single', pt_2d_single(:,1)', pt_2d_single(:,2)', eps_single);
                end

                [~,bestId] = min(abs(log(F./fs)));
                f=double(fs(bestId));
                if l == 2
                    df = f;
                else
                    df = abs((f - F)/F);
                end
                if n ~= 0
                    stats(ind, :, j) = [noise_level{l}(k), df];
                end
            end
            ind = ind + 1;
        end
    end
    f = fopen(file_names{l}, 'wb');
    fprintf(f, 'algorithm,stdev,df\n');
    for j=1:M
        ind = 1;
        for k = 1 : numel(noise_level{l})
            for i = 1:N
            fprintf(f, '%s,%g,%g\n', algonames{j}, stats(ind, 1, j), stats(ind, 2, j));
            ind = ind + 1;
            end
        end
    end
    fclose(f);
end















