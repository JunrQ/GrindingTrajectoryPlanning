%GENERATEPATH generate path
%
% path = generatePathFromClusters(clusters, v, f, n), generate path
% after clusters generated.
%
%Author::
% - JunrZhou
function path = generatePathFromClusters(clusters, v, f, n, gap, method)
if nargin < 6
    method = 0;
end
if nargin < 5
    gap = 1.0;
end
[~, cluster_num] = size(clusters);
pathInfoCell = {};
endPoints = zeros(cluster_num, 6);
for cluIdx=1:cluster_num
    [pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
    % use graph traverse to reorder
    [orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
    [tmp, ~] = size(orderedPointsCloud);
    % save information
    pathInfoCell{cluIdx, 1} = orderedPointsCloud; % points coordinate
    pathInfoCell{cluIdx, 2} = orderedPointsCloudIdx; % index of face
    pathInfoCell{cluIdx, 3} = orderedPointsCloud(1, :); % start point
    pathInfoCell{cluIdx, 4} = orderedPointsCloud(tmp, :); % end point
    endPoints(cluIdx, 1:3) = orderedPointsCloud(1, :);
    endPoints(cluIdx, 4:6) = orderedPointsCloud(tmp, :);
end

% use cluster index and start, end point of the cluster as features
% use greedy algorithm to reorder
clusterOrder = myPrim(endPoints);

% generate path


end