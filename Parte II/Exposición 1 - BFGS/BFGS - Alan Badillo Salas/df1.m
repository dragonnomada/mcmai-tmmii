function dy = df1(x)
    h = 1e-4;
    dy(1) = (f1([x(1) + h, x(2)]) - f1([x(1) - h, x(2)])) / (2 * h);
    dy(2) = (f1([x(1), x(2) + h]) - f1([x(1), x(2) - h])) / (2 * h);
end