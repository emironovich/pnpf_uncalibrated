function [cameras_before_ba, images_before_ba] = read_before_ba(input_path, cameras, images)
    fin = fopen([input_path '/before_ba.txt'], 'r');
    in_pnp = fscanf(fin, "%f");
    fclose(fin);
    
    n = length(in_pnp)/10;
    assert(length(images) == n + 2);
    
    camera_nums = zeros(n, 1);
    fs = zeros(n, 1);
    Rs = zeros(3, 3, n);
    ts = zeros(3, n);
    ind = 1;
    for i = 1:10:length(in_pnp)
        camera_nums(ind) = in_pnp(i);
        fs(ind) = in_pnp(i + 1);
        Rs(:, :, ind) = quat2rotmat(in_pnp((i+3):(i+6)));
        ts(:, ind) = in_pnp(i+7:i+9)';
        ind = ind + 1;
    end
    
    key_set_cameras = zeros(1, n);
    key_set_images = zeros(1, n);
    value_set_cameras = cell(1, n);
    value_set_images = cell(1, n);
    for i = 1:(n+2)
        ind = find(camera_nums == images(i).camera_id);
        
        if(~isempty(ind))
            image_struct = images(i);
            image_struct.R = squeeze(Rs(:,:,ind));
            image_struct.t = ts(:, ind);
            key_set_images(ind) = images(i).image_id;
            value_set_images{ind} = image_struct;

            camera_struct = cameras(images(i).camera_id);
            camera_struct.params(1) = fs(ind);
            camera_struct.params(2) = fs(ind);
            key_set_cameras(ind) = images(i).camera_id;
            value_set_cameras{ind} = camera_struct;
        end
    end
    
    cameras_before_ba = containers.Map(key_set_images, value_set_cameras);
    images_before_ba = containers.Map(key_set_cameras, value_set_images);
    
end