function [n, R, C] = p3p_solver(f1, f2, f3, P1, P2, P3, e)
    % Compute transformation matrix T and vector f_3^T.
    tx = f1;
    tz = cross(f1, f2);
    tz = tz / norm(tz);
    ty = cross(tz, tx);
    T = [tx, ty, tz]';
    f3_T = T*f3;

    % Compute transformation matrix N and world point P_3^n.
    % TODO check nu exists by checking P1P2xP1P3 ~= 0
    nx = (P2 - P1);
    nx = nx / norm(nx);
    nz = cross(nx, P3 - P1);
    nz = nz / norm(nz);
    ny = cross(nz, nx);
    N = [nx, ny, nz]';
    P3_n = N*(P3 - P1);

    % Extract p1 and p2 from P_3^n.
    %P3_n(3) = 0 check??????
    p1 = P3_n(1);
    p2 = P3_n(2);

    % Compute d12 and b.
    d12 = norm(P2 - P1);
    cos_beta = f1'*f2;
    b = sign(cos_beta)*(sqrt(1 / (1 - (cos_beta)^2) - 1));

    % Compute phi1 and phi2.
    phi1 = f3_T(1) / f3_T(3);
    phi2 = f3_T(2) / f3_T(3);

    % Compute factors a0 .... a4 of the polynomial.
    % TODO CHECK
    A = zeros(1, 5);
    A(1) = -phi2^2*p2^4 - phi1^2*p2^4 - p2^4;
    A(2) = 2*p2^3*d12*b + 2*phi2^2*p2^3*d12*b - 2*phi1*phi2*p2^3*d12;
    A(3) = -phi2^2*p1^2*p2^2 - phi2^2*p2^2*d12^2*b^2 - phi2^2*p2^2*d12^2 + phi2^2*p2^4 + ...
            phi1^2*p2^4 + 2*p1*p2^2*d12 + 2*phi1*phi2*p1*p2^2*d12*b - ...
            phi1^2*p1^2*p2^2 + 2*phi2^2*p1*p2^2*d12 - p2^2*d12^2*b^2 - 2*p1^2*p2^2;
    A(4) = 2*p1^2*p2*d12*b + 2*phi1*phi2*p2^3*d12 - 2*phi2^2*p2^3*d12*b - 2*p1*p2*d12^2*b;
    A(5) = -2*phi1*phi2*p1*p2^2*d12*b + phi2^2*p2^2*d12^2 + 2*p1^3*d12 - ...
            p1^2*d12^2 + phi2^2*p1^2*p2^2 - p1^4 - 2*phi2^2*p1*p2^2*d12 + ...
            phi1^2*p1^2*p2^2 + phi2^2*p2^2*d12^2*b^2;

    % Find real roots for cos(theta)
    cos_theta_complex = roots(A);
    cos_theta = zeros(4, 1);
    n = 0;
    for i = 1 : 4
        if imag(cos_theta_complex(i)) < e
            n = n + 1;
            cos_theta(n) = real(cos_theta_complex(i));
        end
    end
    % Find cot(alpha) for each cos(theta)
    cot_alpha = zeros(n, 1);
    for i = 1 : n
        cot_alpha(i) = (phi1*p1/phi2 + cos_theta(i)*p2 - d12*b)/(phi1*cos_theta(i)*p2/phi2 - p1 + d12);
    end

    % Compute all necessaty trigonometric forms of alpha and theta
    sin_alpha = zeros(1, n);
    cos_alpha = zeros(1, n);
    sin_theta = zeros(1, n);

    for i = 1 : n
        sin_alpha(i) = sqrt(1/(1 + cot_alpha(i)^2));
        cos_alpha(i) = sign(cot_alpha(i))*sqrt(1/(1 + 1/(cot_alpha(i))^2));
        sin_theta(i) = -sign(f3_T(3))*sqrt(1 - cos_theta(i)^2);
    end

    % Compute C^n and Q for every solution
    C_n = zeros(3, n);
    Q = zeros(3, 3, n);

    for i = 1 : n
        C_n(:, i) = [d12*cos_alpha(i)*(sin_alpha(i)*b + cos_alpha(i)); ...
                     d12*sin_alpha(i)*cos_theta(i)*(sin_alpha(i)*b + cos_alpha(i)); ...
                     d12*sin_alpha(i)*sin_theta(i)*(sin_alpha(i)*b + cos_alpha(i))];
        Q(:, :, i) = [-cos_alpha(i), -sin_alpha(i)*cos_theta(i), -sin_alpha(i)*sin_theta(i); ...
                       sin_alpha(i), -cos_alpha(i)*cos_theta(i), -cos_alpha(i)*sin_theta(i); ...
                       0, -sin_theta(i), cos_theta(i)];
    end

    % Compute C and R for every solution.
    C = zeros(3, n);
    R = zeros(3, 3, n);
    for i = 1 : n
        C(:, i) = P1 + N'*C_n(:, i);
        R(:, :, i) = N'*squeeze(Q(:, :, i))'*T;
    end

end