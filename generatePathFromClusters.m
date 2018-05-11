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
for cluIdx=1:cluster
    [pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
    % use graph traverse to reorder
    [orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
end
end