function ai = line_search_silent(fname, dfname, x, d)
    MAX_ITER = 10;

    a0 = 1;
    b1 = 1e-4;
    b2 = .99;
    l = 2;
    
    i = 0;
    al = 0;
    ar = Inf;

    ai = a0;

    while i < MAX_ITER
        cond1 = false;
        cond2 = false;
    
        % (11.45) f(xk + αkdk) ≤ f(xk) + αk β1 ∇f(xk)T dk 
        if feval(fname, x + ai * d) <= f(x) + ai * b1 * feval(dfname, x)' * d
            cond1 = true;
        end
    
        if ~cond1
            ar = ai;
            ai = (al + ar) / 2;
        else
            % (11.47) ∇f(xk + αkdk)T dk ≥ β2 ∇f(xk)T dk 
            if feval(dfname, x + ai * d)' * d >= b2 * feval(dfname, x)' * d
                cond2 = true;
            end

            if ~cond2
                al = ai;
                if ar < Inf
                    ai = (al + ar) / 2;
                else
                    ai = l * ai;
                end
            end
        end
    
        i = i + 1;
    
        if cond1 && cond2
            return
        end
    end
end