f=fopen(filename, 'wt');
fprintf(f, 'dF,dR,dC,dt,N\n');
fclose(f);
dlmwrite(filename, arr, '-append');