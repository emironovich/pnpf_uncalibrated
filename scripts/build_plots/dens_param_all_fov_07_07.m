% Build plots of probability density for P3.5Pf, P4Pf and COLMAP 
% with RANSAC and LO-RANSAC for each dataset from bench_names

% 2 x 3 

res_date = '07_07';
param_name = 'f';
trials_num = 9;


bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow','office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard'};%,'delivery_area','electro','facade','kicker','office','pipes','playground','relief','relief_2','terrace','terrains'}; %'facade','kicker'
methods = {'filter_40_140', 'no_filter'};
titles = {'FOV in [40;140]', 'no FOV check'};
specific_name = 'combined_only_good';
method2title = containers.Map(methods, titles);

bar_names = categorical(titles);
bar_names = reordercats(bar_names,titles);

if param_name == 't'
    param_num = 2;
else %f or R
    param_num = 1;
end

for ind_bench = 1 : numel(bench_names)
    
    bench_name = bench_names{ind_bench};
    fig = figure('Name', bench_name, 'WindowState', 'maximized');
    t = tiledlayout(2, 3);
    
    succ_rec = [];
    
    for ind_method = 1 : numel(methods) 
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' res_date];
        combined_name = [specific_name '_' base_name];
        
        [p35p, p4p, real] = read_algo_csv([combined_name '_succ_rec.csv']);
        
        if isempty(p35p)
            p35p = 0;
        end
        if isempty(p4p)
            p4p = 0;
        end
        if isempty(real)
            real = 0;
        end
            
        succ_rec = [succ_rec; p35p, p4p, real];       
    end
    
    for ind_method = 1 : numel(methods)      
        
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' res_date];
        combined_name = [specific_name '_' base_name];
        
        if param_name == 'f'
            [p35p, p4p, real] = read_algo_csv([combined_name '_f.csv']);
        else
            [p35p, p4p, real] = read_algo_csv([combined_name '_Rt.csv']);
        end
        
        a = min([min(log10(p35p(:,param_num))) min(log10(p4p(:,param_num))) min(log10(real(:,param_num)))]);
        b = max([max(log10(p35p(:,param_num))) max(log10(p4p(:,param_num))) max(log10(real(:,param_num)))]);
        x_values = a:0.1:b;
        
        ax{1 + 3*(ind_method - 1)} = nexttile;
        hold on
        for i = 1:trials_num
            curr = p35p(p35p(:,end) == i, param_num);
            if isempty(curr)
                continue;
            end
            try
                pd = fitdist(log10(curr),'Kernel');
                y = pdf(pd,x_values);
                plot(x_values,y,'LineWidth',2)
            catch
                warning(['Problem with plotting for colmap on ' bench_name]);
            end
        end
        hold off
        title(['P3.5P + ' method2title(method_name)]);

        ax{2 + 3*(ind_method - 1)} = nexttile;
        hold on
        for i = 1:trials_num
            curr = p4p(p4p(:,end) == i, param_num);
            if isempty(curr)
                continue;
            end
            try
                pd = fitdist(log10(curr),'Kernel');
                y = pdf(pd,x_values);
                plot(x_values,y,'LineWidth',2)
            catch
                warning(['Problem with plotting for P4P on ' bench_name]);
            end
        end
        hold off
        title(['P4P + ' method2title(method_name)]);
        
        ax_ind_3 = 3 + 3*(ind_method - 1);
        ax{ax_ind_3} = nexttile;
        if ax_ind_3 == 3
            
            bar(bar_names, succ_rec);
            legend('P3.5P', 'P4P', 'COLMAP', 'Location', 'southeast');
            title(['Successful reconstructions number (out of ' num2str(trials_num) ')']);
            
        else
            hold on
            for i = 1:trials_num
                curr = real(real(:,end) == i, param_num);
                if isempty(curr)
                    continue;
                end
                try
                    pd = fitdist(log10(curr),'Kernel');
                    y = pdf(pd,x_values);
                    plot(x_values,y,'LineWidth',2)
                catch
                    warning(['Problem with plottifor COLMAP on ' bench_name]);
                end
            end
            hold off
            title(['COLMAP + ' method2title(method_name)]);
        end
    
        
    end
   linkaxes([ax{1},ax{2},ax{4},ax{5},ax{6}],'xy');
   if param_name == 'f'
        title(t, ['log_{10} относительной ошибки фокусного расстояния в результате работы на датасете ' bench_name ' из eth3d']);
   elseif param_name == 'R'
        title(t, ['log_{10} ошибки во вращении (в градусах) в результате работы на датасете ' bench_name ' из eth3d']);
   else
        title(t, ['log_{10} относительные ошибки в смещении в результате работы на датасете ' bench_name ' из eth3d']);
   end
       saveas(fig, [specific_name '_' bench_name '_' res_date '_' param_name '.png']);
       print(fig, [specific_name '_' bench_name '_' res_date '_' param_name], '-depsc');
end
close all;