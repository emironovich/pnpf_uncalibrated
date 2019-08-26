function solve_3Q3(c) %c -- 3x10 coefficients matrix
%SOLVE_3Q3 Summary of this function goes here
%   Detailed explanation goes here
    A = find_A(c);
    P = find_P(c);
    for i = 1 : 3
        P(:, :, i) = A\P(:, :, i);
    end

end

function A = find_A(c)
    A = [c(1, 2), c(1, 3), c(1, 6);
         c(2, 2), c(2, 3), c(2, 6);
         c(3, 2), c(3, 3), c(3, 6)];
end

function P = find_P(c)
    P = zeros(3, 3, 3); %[x^2, x, 1]
    for i = 1 : 3
        P(i, 1, :) = [0, c(i, 4), c(i, 8)];        %y
        P(i, 2, :) = [0, c(i, 5), c(i, 9)];        %z
        P(i, 3, :) = [c(i, 1), c(i, 7), c(i, 10)]; %1
    end
end

