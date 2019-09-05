%find P
syms x y z;
c = sym('c', [3, 10]);
mons = [x^2; y^2; z^2; x*y; x*z; y*z; x; y; z; 1];

eq = c(1, :) * mons;

[cyz, tyz] = coeffs(eq, [y, z]);

%find M

P = sym('p', 3);
mons = [y; z; 1];

%y^2*z = (yz)*y
eq9_10_11(1) = P(1, :)*mons*z - P(3, :)*mons*y;
%(yz)*z = (z^2)*y
eq9_10_11(2) = P(3, :)*mons*z - P(2, :)*mons*y;
%(yz)*(yz) = (y^2)*(z^2)
eq9_10_11(3) = (P(3, :)*mons)*(P(3, :)*mons) - (P(1, :)*mons)*(P(2, :)*mons);

M = sym('m', 3);

for i = 1 : 3
    eq = eq9_10_11(i);
    [cyz, tyz] = coeffs(eq, [y, z]);
    eq = sum(cyz .* subs(tyz, [y^2; z^2; y*z], P*mons));
    [cyz, tyz] = coeffs(eq, [y, z]);
    M(i, :) = cyz;
end

C = sym('c', [3, 3, 3]);
xs = sym('xs', [3, 3, 3]);
xs(:,:,1) = x^2;
xs(:,:,2) = x;
xs(:,:,3) = 1;

C = C .* xs;
C(:, 1:2, 1) = 0;

polys = sym('p', 3);

for i = 1 : 3
    for j = 1 : 3
        polys(i, j) = sum([C(i, j, 1), C(i, j, 2), C(i, j, 3)]);
    end
end

M = subs(M, [P(1, :), P(2, :), P(3, :)], [polys(1, :), polys(2, :), polys(3, :)]);
filename = 'temp_for_M.txt';
f=fopen(filename, 'wt');
for i = 1 : 3
    for j = 1 : 3
        fprintf(f, "\tM(:, %d, %d) = [", i, j);
        %disp([i, j]);
        [kx, tx] = coeffs(M(i, j), x);
        for k = 1 : 5 - length(kx)
            fprintf(f, "0, ");
        end
        for k = 1 : length(kx)
            if k ~= length(kx)
                fprintf(f, "%s, ", char(kx(k)));
            else
                fprintf(f, "%s]; %% degree = %d\n", char(kx(k)), length(kx) - 1);
            end
        end
    end
end
fclose(f);

fin = fopen(filename, 'r');
fout= fopen('find_M.m', 'wt');
fprintf(fout, "function M = find_M(P)\n");
fprintf(fout, "\tM = zeros(5, 3, 3);\n");
while ~feof(fin)
    c = fread(fin, 1, 'uint8=>char');
    if c == 'c'
        i = fread(fin, 1, 'uint8=>char');
        fread(fin, 1, 'uint8=>char');
        j = fread(fin, 1, 'uint8=>char');
        fread(fin, 1, 'uint8=>char');
        k = fread(fin, 1, 'uint8=>char');
        fprintf(fout, "P(%s, %s, %s)", i, j, k);
    else
        fprintf(fout, "%s", c);
    end
end
fprintf(fout, "end");

fclose(fin);
fclose(fout);

    

