clc;

x = [1, -10];

d = -df(x);

a = line_search("f", "df", x, d);

disp(a)