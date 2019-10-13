function [n,f,r,t] = p4pf_single(X, x, y, e)
    assert(isa(X, 'single'));
    assert(isa(x, 'single'));
    assert(isa(y, 'single'));
    assert(isa(e, 'single'));
    
    % TODO: rename solve_P4Pf to match p3.5p
    [n, f, r, t] = solve_P4Pf(X, x, y, e);
    assert(isa(n, 'int32'));
    assert(isa(t, 'single'));
    assert(isa(r, 'single'));
    assert(isa(f, 'single'));
end

