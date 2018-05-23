%MODIFYQ modify q
%
% qM = modifyQ(q, minDiffQ)
%   1. minDiffQ, make all difference between two qs, large modifyQ
%
function qM = modifyQ(q, minDiffQ)
[m, n] = size(q);
lastIdx = 1;
qM = [];
for i = 2:m
    if any((q(i, 1:6) - q(i-1, 1:6)) > minDiffQ)
        stepLength = floor(max(q(i, 1:6) - q(i-1, 1:6)) / minDiffQ);
        tmpQ = zeros(stepLength, n);
        tmpQ(:, 1:6) = coorInterp([q(i-1, 1:6); q(i, 1:6)], stepLength-1);
        tmpQ(:, 7) = q(i, 7);
        qM = [qM; q(lastIdx:(i-1), :); tmpQ(2:stepLength, :)];
        lastIdx = i;
    end
end
qM = [qM; q(lastIdx:m, :)];
end