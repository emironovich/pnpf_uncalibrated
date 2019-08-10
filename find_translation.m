function T = find_translation(R, fc, fs, li, Xi, xi, yi)
    T = [li*xi - (fc*R(1, :) - fs*R(2, :))*Xi;
         li*yi - (fs*R(1, :) + fc*R(2, :))*Xi;
         li - R(3, :)*Xi];
end