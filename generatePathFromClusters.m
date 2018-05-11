%GENERATEPATH generate path
%
% path = generatePathFromClusters(clusters, v, f, n), generate path
% after clusters generated.
function path = generatePathFromClusters(clusters, v, f, n, gap, method)
if nargin < 6
    method = 0;
end
if nargin < 5
    gap = 1.0;
end
[~, cluster_num] = size(clusters);
pathInfoCell = {};
for cluIdx=1:cluster_num
    [pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
    % use graph traverse to reorder
    [orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
    [tmp, ~] = size(orderedPointsCloud);
    % save information
    pathInfoCell{cluIdx, 1} = orderedPointsCloud;
    pathInfoCell{cluIdx, 2} = orderedPointsCloudIdx;
    pathInfoCell{cluIdx, 3} = orderedPointsCloud(1, :);
    pathInfoCell{cluIdx, 4} = orderedPointsCloud(tmp, :);
end

% use cluster index and start, end point of the cluster as features
% use greedy algorithm to reorder
cluOrder = ones(cluster_num, 1);
for i=1:cluster_num
    
end



end