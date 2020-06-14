function [p35p, p4p, real] = read_algo_csv(file_name)
    t = readmatrix(file_name,'OutputType','char');
    data_size = size(t);
    n = data_size(1);
    param_num = data_size(2) - 1;
    %p3.5p p4p colmap
    algo_data_size = zeros(1, 3);
    for ind = 1 : n
        if strcmp(t{ind, end}, 'p35p')
            algo_data_size(1) = algo_data_size(1) + 1;
        elseif strcmp(t{ind, end}, 'p4p')
            algo_data_size(2) = algo_data_size(2) + 1;
        elseif strcmp(t{ind, end}, 'real')
            algo_data_size(3) = algo_data_size(3) + 1;
        end
    end
    p35p = zeros(algo_data_size(1), param_num);
    p4p = zeros(algo_data_size(2), param_num);
    real = zeros(algo_data_size(3), param_num);
    %p3.5p p4p colmap
    % i     j    k
    i = 1;
    j = 1;
    k = 1;
    
    for ind = 1 : n
        if strcmp(t{ind, end}, 'p35p')
            for indind = 1 : param_num
                p35p(i, indind) = str2num(t{ind, indind});
                i = i + 1;
            end
        elseif strcmp(t{ind, end}, 'p4p')
            for indind = 1 : param_num
                p4p(j, indind) = str2num(t{ind, indind});
                j = j + 1;
            end
        elseif strcmp(t{ind, end}, 'real')
            for indind = 1 : param_num
                real(k, indind) = str2num(t{ind, indind});
                k = k + 1;
            end
        end
    end
end