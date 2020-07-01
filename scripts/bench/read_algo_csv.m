% reads csv files in format:
%       param_1 ... param_n algo_name
% where algo_name is in {'p35p', 'p4p', 'real'}
%
% Input:
% filename -- full file name (ex.: 'comparison_results/file_name.csv')
% Output:
% 3 respective tables with the same column structure
%       param_1 ... param_n

function [p35p, p4p, real] = read_algo_csv(file_name)
    if ~isfile(file_name)
        p35p = [];
        p4p = [];
        real = [];
        return;
    end
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
                p35p(i, indind) = str2double(t{ind, indind});
            end
            i = i + 1;
        elseif strcmp(t{ind, end}, 'p4p')
            for indind = 1 : param_num
                p4p(j, indind) = str2double(t{ind, indind});
            end
            j = j + 1;
        elseif strcmp(t{ind, end}, 'real')
            for indind = 1 : param_num
                real(k, indind) = str2double(t{ind, indind});
            end
            k = k + 1;
        end
    end
end