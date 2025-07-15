clc;

x = [1, -10];

[xk, mlist] = bfgs("f", "df", x, eye(2), 10e-7);

disp(xk)

f(x)
df(x)

f(xk)
df(xk)

save("mlist", "mlist")