%TS2Q transform homogeneous transformation matrixs to qs, Joint coordinates
%
% qs = Ts2q(robot, initQ, step, Ts)
%
%Params::
% - robot,
% - initQ
% - step, step per mm
% - Ts, [4 * pointsNum, 4], homogeneous transformation matrixs
%
%Author::
% - JunrZhou
function qs = Ts2q(robot, initQ, stepLength, Ts)
% from start to Ts(1)
q0 = initQ;
initT = robot.fkine(initQ);
initT = double(initT);
[startTs, startSteps] = myTraj(initT, Ts(1:4, :), stepLength, true);

curQs = zeros(startSteps, 6);
curQs(1, :) = q0;
for i=2:startSteps
    tmpQ = robot.ikine(startTs(i*4-3:i*4, :), 'q0', q0);
    curQs(i, :) = tmpQ;
    q0 = tmpQ;
end

% realloc
lastSteps = startSteps + 1;
[curQs, curLength] = reallocQ(curQs, 2);

[pointsNum, ~] = size(Ts);
pointsNum = pointsNum / 4;

for i=1:(pointsNum-1)
    T1 = Ts(4*i-3:4*i, 1:4);
    T2 = Ts(4*i+1:4*i+4, 1:4);
    [tmpTs, tmpSteps] = myTraj(T1, T2, stepLength);

    if ((lastSteps + tmpSteps) >= curLength)
        [curQs, curLength] = reallocQ(curQs, 2);
    end

    for j=1:tmpSteps
        tmpQ = robot.ikine(tmpTs(i*4-3:i*4, :), 'q0', q0);
        curQs(lastSteps+j, :) = tmpQ;
        q0 = tmpQ;
    end

    lastSteps = lastSteps + tmpSteps + 1;

end
qs = curQs;
end



function [tmpTs, tmpSteps] = myTraj(T0, T1, stepLength, ending)
if nargin < 4
    ending = false;
end
c1 = T0(1:3, 4);
c2 = T1(1:3, 4);

rotateM1 = T0(1:3, 1:3);
rotateM2 = T1(1:3, 1:3);
UQ1 = rotm2quat(rotateM1);
UQ2 = rotm2quat(rotateM2);

tmpLength = norm(c1 - c2);
tmpSteps = floor(tmpLength * stepLength);

tmpCoorInterp = coorInterp([c1; c2], tmpSteps, 'linear');
tmpUnitQuatInterp = slerpInterp(UQ1, UQ2, tmpSteps+1);

if ending
    tmpSteps = tmpSteps + 1;
end
tmpTs = zeros(tmpSteps * 4, 4);
for j=1:tmpSteps
    tmpTs((j*4-3):(j*4-1), 4) = tmpCoorInterp(j, :);
    tmpTs((j*4-3):(j*4-1), 1:3) = quat2rotm(tmpUnitQuatInterp(j, :));
    tmpTs(j*4, 4) = 1;
end
end

function [qr, length] = reallocQ(qi, ratio)
if nargin < 3
    ratio = 2;
end
[m, n] = size(qi);
length = m*ratio;
qr = ones(length, n);
qr(1:m, :) = qi;
end