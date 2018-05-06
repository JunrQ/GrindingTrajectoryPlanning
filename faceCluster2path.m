%FACECLUSTER2PATH given a face cluster generate path
%
% path = faceCluster2path(faces_idx, v, f, n) you should use clusters{i}
% as input, clusters is the output of divideIntoFaces(v, f ,n).
%

function path = faceCluster2path(faces_idx, v, f, n)
faces_coor_idx = f(faces_idx, :);
normal_vec = n(faces_idx, :);
% generate points cloud

% order the points
orderedPointsCloud = myTsp(pointsCloud);
end