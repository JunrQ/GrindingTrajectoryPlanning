classdef CollisionDetector
properties
    stlPath = "/Users/junr/Documents/Works/graduation-project/code/face_traj/gongjian.stl";
    v
    f
    n
    centerP
end

methods
    function cd = CollisionDetector(stlPath)
        if nargin == 1
            cd.stlPath = stlPath;
        end
        [cd.v, cd.f, cd.n] = readStlModel(cd.stlPath, @connectPathPreprocessSTLVFN);
        cd.centerP = getCenterPointsOfFace(cd.v, cd.f);
    end % CollisionDetector
end

methods
    function [nums, points] = traj1(obj, lastP, curP, lastN, curN, l, ps, ns)
    %TRAJ1 very simple
    %
    %Params::
    % - lastP, start position, x, y, z
    % - curP, end position, x, y, z
    % - lastN, start normal vector
    % - curN, end normal vector
    % - l, length along normal vector
    % - ps, [m, 3] all points
    % - ns, [m, 3] all normal vectors
    tmpCount = 1;
    tmpLength = ceil(norm(lastP - curP) * 1.5);
    tmpPoints = zeros(tmpLength, 3);
    tmpP = lastP;
    [numPoints, ~] = size(ps);

    psCells = mat2cell(ps, ones(numPoints, 1), 3);
    repFlag = tmpP;
    tmpPoints(1, :) = lastP + l * lastN;
    while 1
        if norm(tmpP - curP) < 5
            break
        end
        d = cellfun(@(x) norm(x-tmpP), psCells);
        [d_, idx] = sort(d);
        nearest = ps(idx(1:20), :);
        tmpCell = mat2cell(nearest, ones(20, 1), 3);
        dT = cellfun(@(x) norm(x-curP), tmpCell);
        [Y, I] = min(dT);
        tmpP = ps(idx(I), :);
        if all(repFlag == tmpP)
            break
        end
        repFlag = tmpP;
        tmpCount = tmpCount + 1;
        if (tmpCount + 1) >= tmpLength
            tmp = zeros(2 * tmpLength, 3);
            tmp(1:tmpCount, :) = tmpPoints(1:tmpCount, :);
            tmpPoints = tmp;
            tmpLength = 2 * tmpLength;
        end
        tmpPoints(tmpCount, :)  = tmpP + l * ns(idx(I), :);
    end
    tmpPoints(tmpCount + 1, :) = curP + l * curN;
    nums = tmpCount + 1;
    points = tmpPoints(1:(tmpCount + 1), :);
    end
    end

    function [nums, points] = traj2(obj, lastP, curP, lastN, curN, l, stepLength)
    %TRAJ2 Use A-star.
    %
    %Params::
    % - lastP, start position, x, y, z
    % - curP, end position, x, y, z
    % - lastN, start normal vector
    % - curN, end normal vector
    % - l, length along normal vectors
    % - stepLength, step length along the path
    startP = lastP + l * lastN;
    endP = curP + l * curN;

    % initial length of points
    tmpLength = ceil(norm(lastP - curP) * 1.5);
    tmpPoints = zeros(tmpLength, 3);
    tmpCount = 1;

    tmpP = startP;

    while 1
        targetDir = endP - tmpP;
        while 1
            testP = 
        end

        if (tmpCount + 1) >= tmpLength
            tmp = zeros(2 * tmpLength, 3);
            tmp(1:tmpCount, :) = tmpPoints(1:tmpCount, :);
            tmpPoints = tmp;
            tmpLength = 2 * tmpLength;
        end
        tmpPoints(tmpCount, :)  = tmpP + l * ns(idx(I), :);

    end
    end
end