% Server script to iterate trough local/global directories and find when a
% certain camera changed focal_distance

method_name = 'filter_40_140';
dataset_name = 'courtyard';
algo_name = 'p35p';
trial_num = 1;
curr_date = '10_07';

camera_id = 20;

specific_name = 'analysis';
input_path_base = '~/hdd_scratch/data/eth3d_results_fov_aux_07_07';
e = 0.01;

input_path = [input_path_base '/' method_name '/' dataset_name '/' algo_name '/' num2str(trial_num)];

ba_types = {'local', 'global'};

for ind = 1 : length(ba_types)
    curr_ba_type = ba_types{ind};

    fout = fopen([curr_ba_type '_' specific_name '_' method_name '_' dataset_name '_' algo_name '_' num2str(trial_num) '_camera_num_' num2str(camera_id) '.txt'], 'w');
    ba_num = 1;
    while true
        name_before = [input_path '/' curr_ba_type '/cameras_' curr_ba_type(1) num2str(ba_num) '_before.txt'];
        name_after = [input_path '/' curr_ba_type '/cameras_' curr_ba_type(1) num2str(ba_num) '_after.txt'];
        
        if ~isfile(name_before) || ~isfile(name_after)
            break;
        end

        cameras_before = read_cameras(name_before);
        cameras_after = read_cameras(name_after);

        fx_before = cameras_before(camera_id).params(1);
        fy_before = cameras_before(camera_id).params(2);
        fx_after = cameras_after(camera_id).params(1);
        fy_after = cameras_after(camera_id).params(2);

        if abs(fx_before - fx_after) > e || abs(fy_before - fy_after) > e
            fprintf(fout, '#%d: %f %f ------> %f %f\n', ba_num, fx_before, fy_before, fx_after, fy_after);
        end
        ba_num = ba_num + 1; 
    end
    fclose(fout);
end


