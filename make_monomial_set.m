function [mons, arr] = make_monomial_set(pwr, qx, qy, form) %'r' -- row, 'c' -- column
    sz = (2 + pwr)*(pwr + 1)/2;
    %2 -- 6, 4 -- 15, 6 -- 28, 8 -- 45 = sz
    
    cnt = 1;
    arr = zeros(sz, 2);

    %creating array of all monomials 
    for d = 0 : pwr
        for i = 0 : d
            j = d - i;
            arr(cnt, :) = [i, j];
            cnt = cnt + 1;
        end
    end

    %sorting that array in grevlex
    for i = 1 : sz
        for j = 1 : sz - 1
            sum1 = arr(j, 1) + arr(j, 2);
            sum2 = arr(j + 1, 1) + arr(j + 1, 2);
            diff = arr(j, :) - arr(j + 1, :);
            if diff(2) == 0
                if(diff(1) < 0)
                    flag = true;
                else
                    flag = false;
                end
            elseif diff(2) < 0
                flag = true;
            else
                flag = false;
            end

            if not((sum1 > sum2) || (sum1 == sum2 && flag))
                temp = arr(j, :);
                arr(j, :) = arr(j + 1, :);
                arr(j + 1, :) = temp;
            end        
        end
    end
    
    %creating an array of symbolic monomials insted of just array of
    %vectors of powers
    if form == 'r'
        mons = sym('m', [1, sz]);
    elseif form == 'c'
        mons = sym('m', [sz, 1]);
    end
    
    for i = 1 : sz
        mons(i) = qx^arr(i, 1)*qy^arr(i, 2);
    end
end