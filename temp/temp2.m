%making of function mult_for_groebner()
cnt = 1;
sz1 = 28; %4 -- 15, 6 -- 28, 8 -- 45
arr1 = zeros(sz1, 2);

for d = 0 : 6
    for i = 0 : d
        j = d - i;
        arr1(cnt, :) = [i, j];
        cnt = cnt + 1;
    end
end

for i = 1 : sz1
    for j = 1 : sz1 - 1
        sum1 = arr1(j, 1) + arr1(j, 2);
        sum2 = arr1(j + 1, 1) + arr1(j + 1, 2);
        diff = arr1(j, :) - arr1(j + 1, :);
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
            t = arr1(j, :);
            arr1(j, :) = arr1(j + 1, :);
            arr1(j + 1, :) = t;
        end        
    end
end

syms x y;
mons1 = sym('m', [sz1, 1]);
for i = 1 : sz1
    mons1(i) = x^arr1(i, 1)*y^arr1(i, 2);
end

%ordering monomials in grevlex
cnt = 1;
sz2 = 45; %4 -- 15, 6 -- 28, 8 -- 45
arr2 = zeros(sz2, 2);

for d = 0 : 8
    for i = 0 : d
        j = d - i;
        arr2(cnt, :) = [i, j];
        cnt = cnt + 1;
    end
end

for i = 1 : sz2
    for j = 1 : sz2 - 1
        sum1 = arr2(j, 1) + arr2(j, 2);
        sum2 = arr2(j + 1, 1) + arr2(j + 1, 2);
        diff = arr2(j, :) - arr2(j + 1, :);
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
            t = arr2(j, :);
            arr2(j, :) = arr2(j + 1, :);
            arr2(j + 1, :) = t;
        end        
    end
end
%arr2 = [arr2(1:2, :); arr2(4:8, :); arr2(10:end, :)];

syms x y;
mons2 = sym('m', [sz2, 1]);
for i = 1 : sz2
    mons2(i) = x^arr2(i, 1)*y^arr2(i, 2);
end


%multiply by qx^2

S_x2 = arr1 + 2*[ones(28, 1), zeros(28,1)];
ind_x2 = zeros(28, 1);
mons_x2 = sym('m', [28, 1]);
for i = 1 : 28
    for j = 1 : 45
        if S_x2(i, 1) == arr2(j, 1) && S_x2(i, 2) == arr2(j, 2)
            ind_x2(i) = j;
            mons_x2(i) = mons2(j);
            break;
        end
    end
end

%[ind_x2, [1:28]']


%multiply by qxqy
S_xy = arr1 + ones(28, 2);
ind_xy = zeros(28, 1);
mons_xy = sym('m', [28, 1]);
for i = 1 : 28
    for j = 1 : 45
        if S_xy(i, 1) == arr2(j, 1) && S_xy(i, 2) == arr2(j, 2)
            ind_xy(i) = j;
            mons_xy(i) = mons2(j);
            break;
        end
    end
end

%[ind_xy, [1:28]']

%multiply by qx
S_x = arr1 + [ones(28, 1), zeros(28, 1)];
ind_x = zeros(28, 1);
mons_x = sym('m', [28, 1]);
for i = 1 : 28
    for j = 1 : 45
        if S_x(i, 1) == arr2(j, 1) && S_x(i, 2) == arr2(j, 2)
            ind_x(i) = j;
            mons_x(i) = mons2(j);
            break;
        end
    end
end

%[ind_x, [1:28]']

%multiply by qy
S_y = arr1 + [zeros(28, 1), ones(28, 1)];
ind_y = zeros(28, 1);
mons_y = sym('m', [28, 1]);
for i = 1 : 28
    for j = 1 : 45
        if S_y(i, 1) == arr2(j, 1) && S_y(i, 2) == arr2(j, 2)
            ind_y(i) = j;
            mons_y(i) = mons2(j);
            break;
        end
    end
end

%[ind_y, [1:28]']

%multiply by 1
S_1 = arr1;
ind_1 = zeros(28, 1);
mons_1 = sym('m', [28, 1]);
for i = 1 : 28
    for j = 1 : 45
        if S_1(i, 1) == arr2(j, 1) && S_1(i, 2) == arr2(j, 2)
            ind_1(i) = j;
            mons_1(i) = mons2(j);
            break;
        end
    end
end
%[ind_1, [1:28]']

%it appears to be that there total of 44 monomials insted of 43
U = union(S_x2, union(S_xy, union(S_x, union(S_y, S_1, 'rows'), 'rows'), 'rows'), 'rows'); 

