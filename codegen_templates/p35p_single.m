function [n,f,r,t] = p35p_single(X, x, y, e)
    assert(isa(X, 'single'));
    assert(isa(x, 'single'));
    assert(isa(y, 'single'));
    assert(isa(e, 'single'));
    
    [n, f, r, t] = p35p_solver(X, x, y, e);
    assert(isa(n, 'int32'));
    assert(isa(t, 'single'));
    assert(isa(r, 'single'));
    assert(isa(f, 'single'));
end

