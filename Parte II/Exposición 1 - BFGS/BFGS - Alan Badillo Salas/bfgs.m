function [xk, mlist] = bfgs(fname, dfname, xo, Ho, eps)
    MAX_ITER = 1000;

    k = 0;

    [~, n] = size(xo);

    disp(n)

    I = eye(n);

    xk = xo;

    dfk = feval(dfname, xk);

    mlist = zeros(MAX_ITER + 1, n, 8 + n);

    while k <= MAX_ITER && norm(dfk) > eps
        k = k + 1;
        %disp("k=")
        %disp(k)

        dk = (-Ho * dfk')';
        %disp("dk=")
        %disp(dk)
        mlist(k, :, 1) = dk';
        
        ak = line_search_silent(fname, dfname, xk, dk);
        %disp("ak=")
        %disp(ak)
        mlist(k, :, 2) = [ak; 0]';

        xu = xk;
        mlist(k, :, 3) = xu';

        dfu = dfk;
        mlist(k, :, 4) = dfu';

        xk = xk + ak * dk;
        %disp("xk=")
        %disp(xk)
        mlist(k, :, 5) = xk';

        dfk = feval(dfname, xk);
        %disp("dfk=")
        %disp(dfk)
        mlist(k, :, 6) = dfk';
        

        du = xk - xu;
        %disp("du=")
        %disp(du)
        mlist(k, :, 7) = du';

        yu = dfk - dfu;
        %disp("yu=")
        %disp(yu)
        mlist(k, :, 8) = yu';

        %disp("---------------")
        %disp(du' * yu)
        %disp(du * yu')
        %disp("---------------")

        Ho = (I - (du' * yu) / (du * yu')) * Ho * (I - (yu' * du) / (du * yu')) + (du' * du) / (du * yu');
        mlist(k, :, 9:8+n) = Ho;

        %disp(Ho)

        %disp("------------------------------")
    end
end