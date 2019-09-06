function li = find_lamda(R, fc, fs, Xi, Xj, xi, xj)
    li = -(fc*R(1, :) - fs*R(2, :) - xj*R(3, :))*(Xj - Xi)/(xi - xj);
end