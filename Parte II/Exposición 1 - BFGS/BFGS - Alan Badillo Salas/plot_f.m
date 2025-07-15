x = linspace(-3, 3, 100);
y = linspace(-3, 3, 100);

[X, Y] = meshgrid(x, y);

F = arrayfun(@(x, y) f([x, y]), X, Y);

figure;
contour(X, Y, F, 20);
hold on;