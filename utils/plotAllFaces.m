function plotAllFaces(v, f)
[m, ~] = size(f);
for i=1:m
    plot3(v(f(i, :)', 1), v(f(i, :)', 2), v(f(i, :)', 3), 'k-', 'LineWidth', 1);
    hold on;
end
end