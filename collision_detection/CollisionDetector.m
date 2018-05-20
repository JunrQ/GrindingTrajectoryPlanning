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
    

    function [nums, points] = traj2(obj, lastP, curP, lastN, curN, l, stepLength, ratio)
    %TRAJ2 Use A-star.
    %
    % [tmpTs1Num, tmpPathPoints] = detector.traj2(lastCoor, tmpPath, ...
    %                                             normalVecs(i-1, :), tmpNormalVec,...
    %                                             4, 2, 0.1);
    %
    % **NOTE**: if you find this func takes a long time to run, maybe five minutes,
    %           you shuld interupt, and change the parameters. If l is too small or
    %           ratio is improper, the search algorithm will just loop around infinitely.
    %
    %Params::
    % - lastP, start position, x, y, z
    % - curP, end position, x, y, z
    % - lastN, start normal vector
    % - curN, end normal vector
    % - l, length along normal vectors
    % - stepLength, step length along the path
    % - ratio, len(end-p) / len(start-p) = ratio
    startP = lastP + l * lastN;
    endP = curP + l * curN;

    MAX = 1000;

    candiateDir = [1 0 0;
                   0 1 0;
                   0 0 1;
                   1/sqrt(2) 1/sqrt(2) 0;
                   1/sqrt(2) 0 1/sqrt(2);
                   0 1/sqrt(2) 1/sqrt(2);
                   1/sqrt(2) -1/sqrt(2) 0;
                   1/sqrt(2) 0 -1/sqrt(2);
                   0 1/sqrt(2) -1/sqrt(2)
                   1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
                   -1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
                   1/sqrt(3) -1/sqrt(3) 1/sqrt(3);
                   1/sqrt(3) 1/sqrt(3) -1/sqrt(3)];
    candiateDir = [candiateDir; -candiateDir];
    [dirNum, ~] = size(candiateDir);

    % initial length of points
    tmpLength = ceil(norm(lastP - curP) * 1.5);
    tmpPoints = zeros(tmpLength, 3);
    tmpCount = 2;
    tmpPoints(1, :) = startP;
    [numPoints, ~] = size(obj.centerP);
    tmpP = startP;

    tmpDist = zeros(dirNum, 1);
    % tmpTestPoints = zeros(26, 3);

    lastI = 100;

    while 1
        % targetDir = endP - tmpP;
        psCells = mat2cell(obj.centerP, ones(numPoints, 1), 3);
        d = cellfun(@(x) norm(x-tmpP), psCells);
        [~, minI] = min(d);
        % minF = obj.v(obj.f(minI, :), :);

        flag = false;
        while 1
            for i=1:dirNum
                testP = tmpP + stepLength * candiateDir(i, :);
                if (abs(abs(i - lastI) - dirNum/2) < 1e-5)
                    tmpDist(i) = MAX;
                elseif pointFaceRela(testP, obj.v(obj.f(minI, 1), :), obj.n(minI, :))
                    tmpDist(i) = norm((testP - endP)) + ratio *  norm((testP - startP));
                else
                    tmpDist(i) = MAX;
                end 
            end
            [tmpV, tmpI] = min(tmpDist);
            lastI = tmpI;
            if abs(tmpV - MAX) > 1
                flag = true;
                tmpP = tmpP + stepLength * candiateDir(tmpI, :);
            end

            if flag
                break
            else
                stepLength = stepLength * 1.5;
            end
        end

        if (tmpCount + 1) >= tmpLength
            tmp = zeros(2 * tmpLength, 3);
            tmp(1:tmpCount, :) = tmpPoints(1:tmpCount, :);
            tmpPoints = tmp;
            tmpLength = 2 * tmpLength;
        end
        tmpPoints(tmpCount, :)  = tmpP;
        
        if norm(tmpP - endP) < 5
            break
        end
        tmpCount = tmpCount + 1;
    end
    tmpPoints(tmpCount + 1, :) = endP;
    nums = tmpCount + 1;
    points = tmpPoints(1:(tmpCount + 1), :);
    end
end
end