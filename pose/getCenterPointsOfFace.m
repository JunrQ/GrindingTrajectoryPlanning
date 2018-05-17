function cPoints = getCenterPointsOfFace(v, f)
%GETCENTERPOINTSOFFACE get center points of triangle
% cPoints = getCenterPointsOfFace(v, f)
[m, ~] = size(f);
cPoints = zeros(m, 3);
for i=1:m
    cPoints(i, :) = mean(v(f(i, :)', :), 1);
end
end