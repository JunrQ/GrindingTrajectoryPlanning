%MODIFYNORMALVEC modify normal vec
%
% vectors = modifyNoramVec(inputVec)
%   1. make vector smooth
%   2. make it points to z+ [REMOVED]
%
%Author::
% - JunrZhou
function outVec = modifyNormalVec(inputVec, length, modifyXY)
if nargin < 3
    modifyXY = true;
end
if nargin < 2
    length = 10;
end
% length = length + 1;
[m, ~] = size(inputVec);

outVec = inputVec;
tmpLength = 0;
lastVec = inputVec(1, :);

for i=1:m
    curVec = inputVec(i, :);
    if all(lastVec == curVec)
        tmpLength = tmpLength + 1;
    else
        if (abs(tmpLength - 1) > 1e-5)
            if (tmpLength < length)
                tmpVec = coorInterp([lastVec; curVec], tmpLength);
                outVec((i-tmpLength):(i-1), :) = tmpVec(1:tmpLength, :);
            else
                tmpVec = coorInterp([lastVec; curVec], length);
                outVec((i-length):(i-1), :) = tmpVec(1:length, :);
            end
        end
        lastVec = curVec;
        tmpLength = 1;
    end
end

outVec = -outVec;

if modifyXY
    for i = 1:m
        if outVec(i, 3) > 0
            outVec(i, 1:2) = outVec(i, 1:2) * 3;
        else
            outVec(i, 1:2) = outVec(i, 1:2) / 5;
        end
        outVec(i, :) = outVec(i, :) / norm(outVec(i, :));
    end
end
end