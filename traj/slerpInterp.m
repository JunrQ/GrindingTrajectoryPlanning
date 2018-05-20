%SLERPINTERP Spherical linear interpolation of unit quaternion.
%
% qs = slerpInterp(q1, q2, length, shortest)
%
% **NOTE**: if q1, q2 are too close, we just do linear interplation.
%
%Author::
% - JunrZhou

function qs = slerpInterp(q1, q2, length, shortest)
qs = zeros(length, 4);
if nargin < 4
    shortest = true;
end
cosTheta = q1 * q2';
if shortest
    if cosTheta < 0
        q1 = -q1;
        cosTheta = -cosTheta;
    end
end

theta = acos(cosTheta);

r = linspace(0, 1, length);
if cosTheta > 1 - 1e-6
    % if too close, just linear interpolate
    qs = coorInterp([q1; q2], length-1, 'linear');
else
    for i=1:length
        qs(i, :) = (sin((1-r(i))*theta) * q1 + sin(r(i)*theta) * q2) / sin(theta);
    end
end
end