%FACECLUSTER2PATH given a face cluster generate path
%
% path = faceCluster2path(faces_idx, v, f, n) you should use clusters{i}
% as input, clusters is the output of divideIntoFaces(v, f ,n).
%

function path = faceCluster2path(faces_idx, v, f, n)
faces_coor_idx = f(faces_idx, :); % several faces
normal_vec = n(faces_idx, :); % several normal vectors

% generate points cloud
% for the fact there is no straight line connection between
% two point in different face, the points cloud should contain
% face information. Then when we calculate distance between 
% those points, we consider the fact that they are not in the
% same face.
% If two points are not adjoint, their distance are MAX.
% **adjoint**: like DIP 8-, 4-, 
[pointsCloud, pointsCloudFaceIdx, pointsCloudAdjPointsIdx] = ...
generatePointsCloud(faces_idx, v, f, n, number_adjoint, adjoint_length);



% order the points
orderedPointsCloud = myTraverser(pointsCloud);
end