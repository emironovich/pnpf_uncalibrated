function write_to_cvs(filename, arr, headers)
    f=fopen(filename, 'wt');
%     fprintf(f, 'dF,dR,dC,dt,N\n');
    fprintf(f, '%s\n', headers);
    fclose(f);
    dlmwrite(filename, arr, '-append');
end