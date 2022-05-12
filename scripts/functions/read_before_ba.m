% read before_ba.txt from input_path and return read_model-like output
%
% INPUT: input_path -- path to before_ba.txt
%        cameras, images -- output from read_model(input_path)
%
% OUTPUT: cameras_before_ba, images_before_ba -- the same cameras/images
%         maps (no new cameras/images added),
%         but with f, R, t that are taken from before_ba.txt file
%         (from multiple entries the last one is chosen)

function [cameras_before_ba, images_before_ba] = read_before_ba(input_path, cameras, images)
    fin = fopen([input_path '/before_ba.txt'], 'r');
    in_pnp = fscanf(fin, "%f");
    fclose(fin);
    
    n = length(in_pnp)/10;

    camera_nums = zeros(n, 1);
    fs = zeros(n, 1);
    Rs = zeros(3, 3, n);
    ts = zeros(3, n);
    ind = 1;
    for k = 1:10:length(in_pnp)
        camera_nums(ind) = in_pnp(k);
        fs(ind) = in_pnp(k + 1);
        Rs(:, :, ind) = quat2rotmat(in_pnp((k+3):(k+6)));
        ts(:, ind) = in_pnp(k+7:k+9)';
        ind = ind + 1;
    end
    
    key_set_cameras = zeros(1, n);
    key_set_images = zeros(1, n);
    value_set_cameras = cell(1, n);
    value_set_images = cell(1, n);
    reconstruction_size = 0;
    
    image_keys = keys(images);
    for i = 1:length(images)
        k = image_keys{i};
        all_ind = find(camera_nums == images(k).camera_id);
        
        if(~isempty(all_ind))
            reconstruction_size = reconstruction_size + 1;

            ind = all_ind(end);
            image_struct = images(k);
            image_struct.R = squeeze(Rs(:,:,ind));
            image_struct.t = ts(:, ind);
            key_set_images(reconstruction_size) = k; % images(i).image_id
            value_set_images{reconstruction_size} = image_struct;

            camera_struct = cameras(images(k).camera_id);
            camera_struct.params(1) = fs(ind);
            camera_struct.params(2) = fs(ind);
            key_set_cameras(reconstruction_size) = images(k).camera_id;
            value_set_cameras{reconstruction_size} = camera_struct;
        end
    end

    key_set_cameras = key_set_cameras(1:reconstruction_size);
    key_set_images = key_set_images(1:reconstruction_size);
    value_set_cameras = value_set_cameras(1:reconstruction_size);
    value_set_images = value_set_images(1:reconstruction_size);
    
    cameras_before_ba = containers.Map(key_set_cameras, value_set_cameras);
    images_before_ba = containers.Map(key_set_images, value_set_images);
end