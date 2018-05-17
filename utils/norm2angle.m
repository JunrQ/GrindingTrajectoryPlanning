%NORM2ANGLE Return angle in degrees of two normal vector
%
% angle = norm2angle(n1, n2)
%
% - n1, n2, normal vectors in 3D space
function angle = norm2angle(n1, n2)
% cos
c = dot(n1, n2) / (norm(n1, 2) * norm(n2, 2));
% angle
angle = acos(c) / pi * 180;
end