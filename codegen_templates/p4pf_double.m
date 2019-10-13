function [n,f,r,t] = p4pf_double(X, x, y, e)
    assert(isa(X, 'double'));
    assert(isa(x, 'double'));
    assert(isa(y, 'double'));
    assert(isa(e, 'double'));
    
    [n, f, r, t] = solve_P4Pf(X, x, y, e);
    assert(isa(n, 'int32'));
    assert(isa(f, 'double'));
    assert(isa(r, 'double'));
    assert(isa(t, 'double'));
end