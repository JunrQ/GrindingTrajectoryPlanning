%GENERATEPATH generate path
%
% [pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, gap, method), generate path
% after clusters generated.
%
%Author::
% - JunrZhou
function [pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, gap, method)
if nargin < 6
    method = 0;
end
if nargin < 5
    gap = 0.5;
end
[~, cluster_num] = size(clusters);
pathInfoCell = {};
endPoints = zeros(cluster_num, 6);
totalPointsNum = 0;
for cluIdx=1:cluster_num
    [pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
    % use graph traverse to reorder
    [orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
    % orderedPointsCloud = pointsCloud;
    % orderedPointsCloudIdx =  pointsCloudFaceIdx;
    [tmp, ~] = size(orderedPointsCloud);
    totalPointsNum = tmp + totalPointsNum;
    % save information
    pathInfoCell{cluIdx, 1} = orderedPointsCloud; % points coordinate
    pathInfoCell{cluIdx, 2} = orderedPointsCloudIdx; % index of face
    pathInfoCell{cluIdx, 3} = orderedPointsCloud(1, :); % start point
    pathInfoCell{cluIdx, 4} = orderedPointsCloud(tmp, :); % end point
    pathInfoCell{cluIdx, 5} = tmp; % number of points
    endPoints(cluIdx, 1:3) = orderedPointsCloud(1, :);
    endPoints(cluIdx, 4:6) = orderedPointsCloud(tmp, :);
end

% use cluster index and start, end point of the cluster as features
% use greedy algorithm to reorder
clusterOrder = myPrim(endPoints);

% generate path
pointsPath = zeros(totalPointsNum, 3);
pointsPathIdx = zeros(totalPointsNum, 1);
clustersIdx = zeros(totalPointsNum, 1);
tmpCount = 0;
for i=1:cluster_num
    tmp = pathInfoCell{i, 5};
    pointsPath((tmpCount+1):(tmpCount+tmp), :) = pathInfoCell{i, 1};
    pointsPathIdx((tmpCount+1):(tmpCount+tmp)) = pathInfoCell{i, 2};
    clustersIdx((tmpCount+1):(tmpCount+tmp)) = i * ones(tmp, 1);
    tmpCount = tmpCount+tmp;
end
end