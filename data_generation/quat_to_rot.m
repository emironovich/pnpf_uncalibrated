function R = quat_to_rot(q)
    w = q(1);
    x = q(2);
    y = q(3);
    z = q(4);
    s = 1/(w^2 + x^2 + y^2 + z^2);
    R = [1 - 2*s*(y^2 + z^2), 2*s*(x*y - z*w), 2*s*(x*z + y*w); 
        2*s*(x*y + z*w), 1 - 2*s*(x^2 + z^2), 2*s*(y*z - x*w);
        2*s*(x*z - y*w), 2*s*(y*z + x*w), 1 - 2*s*(x^2 + y^2)];
end

function R = quat_to_rot_mod(q, p)
    w = q(1);
    x = q(2);
    y = q(3);
    z = q(4);
    s = powermod(w^2 + x^2 + y^2 + z^2, p - 2, p);
    R = [1 - 2*s*(y^2 + z^2), 2*s*(x*y - z*w), 2*s*(x*z + y*w); 
        2*s*(x*y + z*w), 1 - 2*s*(x^2 + z^2), 2*s*(y*z - x*w);
        2*s*(x*z - y*w), 2*s*(y*z + x*w), 1 - 2*s*(x^2 + y^2)];
end