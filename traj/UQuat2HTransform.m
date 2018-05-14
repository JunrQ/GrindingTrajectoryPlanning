%HTRANSFORM2UQUAT Convert Unit Quaternion to homogeneous transform
%
% T = UQuat2HTransform(s, v) **NOTE**: This assume input is unit
% quaternion and return homegeneous transform matrix.
%
% see: Robotics Toolbox for MATLAB/code/robot/UnitQuaternion.m
%
%Author::
% - ZhouJunr

function T = UQuat2HTransform(s, v)
    x = v(1);
    y = v(2);
    z = v(3);
    T = ones(4, 4);
    R = [   1-2*(y^2+z^2)   2*(x*y-s*z) 2*(x*z+s*y)
            2*(x*y+s*z) 1-2*(x^2+z^2)   2*(y*z-s*x)
            2*(x*z-s*y) 2*(y*z+s*x) 1-2*(x^2+y^2)   ];
    T(1:3, 1:3) = R;
    T(1, 4) = 0;
    T(2, 4) = 0;
    T(3, 4) = 0;
end