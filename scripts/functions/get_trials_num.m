function n = get_trials_num(path_to_fov)
    n = 0;
    fov_file_name = [path_to_fov '/fov.txt'];
    if ~isfile(fov_file_name)
        return;
    end
    fin = fopen(fov_file_name, 'r');
    in_pnp = fscanf(fin, "%f");
    fclose(fin);
    n = length(in_pnp) / 3;
end