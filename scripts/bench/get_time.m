num_trials = 20;
n = 38;

algo_names = {'p35p', 'p4p', 'real'};

camera_time = zeros(n, num_trials, numel(algo_names));

for j = 1 : numel(algo_names)
    for i = 1 : num_trials
        input_path_base = ['data/ransac_03_05_snd/' algo_names{j} '/' num2str(i)];
        fid = fopen([input_path_base '/pose_time.txt']);
        pairs = fscanf(fid, '%d %d\n', [2, (n-2)]);
        for k = 1:(n-2)
            camera_time(pairs(1, k), i, j) = pairs(2, k);
        end
        fclose(fid);
    end
end

ind = true(1,n);
ind(4) = false;
ind(7) = false;
camera_time = camera_time(ind,:,:);
n  = n-2;
means = zeros(n,numel(algo_names));
stds = zeros(n,numel(algo_names));

for j = 1 : numel(algo_names)
    for i = 1 : n
        means(i, j) = mean(squeeze(camera_time(i,:,j)));
        stds(i, j) = std(squeeze(camera_time(i,:,j)));
    end
end

tiledlayout(1,3);
ii = 1;

x=[log10(camera_time(ii,:,1)');log10(camera_time(ii,:,2)');log10(camera_time(ii,:,3)')];
g1 = repmat({'P3.5Pf'},20,1);
g2 = repmat({'P4Pf'},20,1);
g3 = repmat({'COLMAP'},20,1);
g = [g1; g2; g3];
ax{1} = nexttile;
boxplot(x,g);

ii = 24;

x=[log10(camera_time(ii,:,1)');log10(camera_time(ii,:,2)');log10(camera_time(ii,:,3)')];
g1 = repmat({'P3.5Pf'},20,1);
g2 = repmat({'P4Pf'},20,1);
g3 = repmat({'COLMAP'},20,1);
g = [g1; g2; g3];
ax{2} = nexttile;
boxplot(x,g);

ii = 17;

x=[log10(camera_time(ii,:,1)');log10(camera_time(ii,:,2)');log10(camera_time(ii,:,3)')];
g1 = repmat({'P3.5Pf'},20,1);
g2 = repmat({'P4Pf'},20,1);
g3 = repmat({'COLMAP'},20,1);
g = [g1; g2; g3];
ax{3} = nexttile;
boxplot(x,g);

linkaxes([ax{1},ax{2},ax{3}],'y');


