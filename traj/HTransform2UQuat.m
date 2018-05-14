%HTRANSFORM2UQUAT Convert homogeneous transform to a Unit Quaternion
%
% [s, v] = HTransform2UQuat(T) **NOTE**: This assume input matrix is 
% a 4*4 homogeneous transform matrix. Return s, v of an unit 
% quaternion.
%
% see: Robotics Toolbox for MATLAB/code/robot/UnitQuaternion.m
%
%Author::
% - ZhouJunr

function [s, v] = HTransform2UQuat(T)
R = T(1:3, 1:3);
s = sqrt(trace(R) + 1) / 2.0;
kx = R(3,2) - R(2,3);   % Oz - Ay
ky = R(1,3) - R(3,1);   % Ax - Nz
kz = R(2,1) - R(1,2);   % Ny - Ox

if (R(1,1) >= R(2,2)) && (R(1,1) >= R(3,3))
    kx1 = R(1,1) - R(2,2) - R(3,3) + 1; % Nx - Oy - Az + 1
    ky1 = R(2,1) + R(1,2);          % Ny + Ox
    kz1 = R(3,1) + R(1,3);          % Nz + Ax
    add = (kx >= 0);
elseif (R(2,2) >= R(3,3))
    kx1 = R(2,1) + R(1,2);          % Ny + Ox
    ky1 = R(2,2) - R(1,1) - R(3,3) + 1; % Oy - Nx - Az + 1
    kz1 = R(3,2) + R(2,3);          % Oz + Ay
    add = (ky >= 0);
else
    kx1 = R(3,1) + R(1,3);          % Nz + Ax
    ky1 = R(3,2) + R(2,3);          % Oz + Ay
    kz1 = R(3,3) - R(1,1) - R(2,2) + 1; % Az - Nx - Oy + 1
    add = (kz >= 0);
end

if add
    kx = kx + kx1;
    ky = ky + ky1;
    kz = kz + kz1;
else
    kx = kx - kx1;
    ky = ky - ky1;
    kz = kz - kz1;
end
nm = norm([kx ky kz]);
if nm == 0
    s = 1;
    v = [0 0 0];
else
    v = [kx ky kz] * sqrt(1 - s^2) / nm;
end

end