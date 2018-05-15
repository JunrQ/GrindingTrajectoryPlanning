%MODIFYNORMALVEC modify normal vec
%
% vectors = modifyNoramVec(inputVec)
%   1. make vector smooth
%   2.
%Author::
% - JunrZhou
function outVec = modifyNormalVec(inputVec)
[m, n] = size(inputVec);

outVec = zeros(m, n);
tmpLength = 0;
lastIdx = 1;
lastVec = inputVec(1, :);

for i=1:m
    curVec = inputVec(i, :);
    if all(lastVec == curVec)
        tmpLength = tmpLength + 1;
    else
        if (abs(tmpLength) < 1e-5)
            outVec(i, :) = curVec;
        else
            tmpVec = coorInterp([lastVec; curVec], tmpLength);
            outVec(lastIdx:(lastIdx+tmpLength), :) = tmpVec;
        end
        lastIdx = i+1;
        lastVec = curVec;
        tmpLength = 0;
    end
end

for i = 1:m
    if outVec(i, 3) > 0
        outVec(i, 1:2) = outVec(i, 1:2) * 2;
    else
        outVec(i, 1:2) = outVec(i, 1:2) / 4 ;
    end
    outVec(i, :) = outVec(i, :) / norm(outVec(i, :));
end
end