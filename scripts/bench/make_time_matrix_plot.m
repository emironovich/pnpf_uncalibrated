input_path = 'scripts/bench/courtyard/data/ransac_09_03/';
X = zeros(36, 3);

fin = fopen([input_path 'p35p/1/pose_time.txt'], 'r');
in_pnp = fscanf(fin, "%f");
X(:, 2) = in_pnp;
fclose(fin);

fin = fopen([input_path 'p4p/1/pose_time.txt'], 'r');
in_pnp = fscanf(fin, "%f");
X(:, 3) = in_pnp;
fclose(fin);

fin = fopen([input_path 'real/1/pose_time.txt'], 'r');
in_pnp = fscanf(fin, "%f");
X(:, 1) = in_pnp;
fclose(fin);

% figure;
% plotmatrix(log10(X));
% dim = [.2 .625 .3 .3];
% str = 'Colmap';
% annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','none');
% 
% dim = [.47 .35 .3 .3];
% str = 'P3.5Pf';
% annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','none');
% 
% dim = [.75 .07 .3 .3];
% str = 'P4Pf';
% annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','none');
% 
% print -depsc time_22_04.eps

tiledlayout(1,3);
ax1 = nexttile;
histogram(log10(X(:, 1)));
title("COLMAP");

ax2 = nexttile;
histogram(log10(X(:, 2)));
title("P3.5Pf");

ax3 = nexttile;
histogram(log10(X(:, 3)));
title("P4Pf");

linkaxes([ax1,ax2,ax3],'xy');
%print -depsc time_histo_02_06.eps
