% Build matrixplots of time for P3.5Pf, P4Pf and COLMAP 
% with RANSAC and LO-RANSAC for each dataset from bench_names

% 1 x 2

res_date = '15_06';
param_name = 'time';
trials_num = 9;

%bench_names = {'courtyard','delivery_area','electro','facade','kicker','office','pipes','playground','relief','relief_2','terrace','terrains'}; %'facade','kicker'
bench_names = {'courtyard'};
methods = {'loransac', 'ransac'};

for ind_bench = 1 : numel(bench_names)
    
    bench_name = bench_names{ind_bench};
    fig = figure('Name', bench_name, 'WindowState', 'maximized');
    t = tiledlayout(1,2);
    
    for ind_method = 1 : numel(methods)      
        
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' res_date];
        input_path_base = ['data/eth3d_results_' res_date '/' method_name '/' bench_name];
        
        p35p = [];
        p4p = [];
        colmap = [];
        
        ax{ind_method} = nexttile;
        for i = 1:trials_num
            file_name = [input_path_base '/p35p/' num2str(i) '/pose_time.txt'];
            if ~isfile(file_name)
                continue;
            end
            fin = fopen(file_name, 'r');
            in_pnp = fscanf(fin, "%f");
            p35p = [p35p; in_pnp];
            fclose(fin);
        end
        
        for i = 1:trials_num
            file_name = [input_path_base '/p4p/' num2str(i) '/pose_time.txt'];
            if ~isfile(file_name)
                continue;
            end
            fin = fopen(file_name, 'r');
            in_pnp = fscanf(fin, "%f");
            p4p = [p4p; in_pnp];
            fclose(fin);
        end
        
        for i = 1:trials_num
            file_name = [input_path_base '/real/' num2str(i) '/pose_time.txt'];
            if ~isfile(file_name)
                continue;
            end
            fin = fopen(file_name, 'r');
            in_pnp = fscanf(fin, "%f");
            colmap = [colmap; in_pnp];
            fclose(fin);
        end
        
%         len = min([length(p35p), length(p4p), length(colmap)]);
%         
%         X = [p35p(1:len); p4p(1:len); colmap(1:len)];
%         [S,AX,BigAx,H,HAx] = plotmatrix(log10(X));
%          title(upper(method_name));
%         xlabel(AX(3, 1), 'P3.5Pf');
%         xlabel(AX(3, 2), 'P4Pf');
%         xlabel(AX(3, 3), 'COLMAP');
%         ylabel(AX(1, 1), 'P3.5Pf');
%         ylabel(AX(2, 1), 'P4Pf');
%         ylabel(AX(3, 1), 'COLMAP');
        x=[log10(p35p); log10(p4p); log10(colmap)];
        g1 = repmat({'P3.5Pf'},length(p35p),1);
        g2 = repmat({'P4Pf'},length(p4p),1);
        g3 = repmat({'COLMAP'},length(colmap),1);
        g = [g1; g2; g3];
        boxplot(x,g);
        title(upper(method_name));
    end
    linkaxes([ax{1},ax{2}],'xy');
    title(t, ['log_{10} от времени работы в наносекундах на датасете ' bench_name ' из eth3d']);

        %saveas(fig, ['combined_' bench_name '_' res_date '_' param_name '.png']);
     print(fig, ['multi_time_' bench_name '_' res_date '_box_plots'], '-depsc');
end
%close all;