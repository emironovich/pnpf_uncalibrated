%this is an auxiliary function that creates a system of equations for 3Q3
function [x, y, z, c10] = make_system()
    x = rand();
    y = rand();
    z = rand();
    c9 = rand(3, 9);
    mons = [x^2; y^2; z^2; x*y; x*z; y*z; x; y; z];
    c10 = [c9, -c9*mons];
end