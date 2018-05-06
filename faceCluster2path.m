%FACECLUSTER2PATH given a face cluster generate path
%
% path = faceCluster2path(faces_idx, v, f, n) you should use clusters{i}
% as input, clusters is the output of divideIntoFaces(v, f ,n).
%

function path = faceCluster2path(faces_idx, v, f, n)
faces_coor_idx = f(faces_idx, :);
normal_vec = n(faces_idx, :);

% generate points cloud
% for the fact there is no straight line connection between
% two point in different face, the points cloud should contain
% face information. Then when we calculate distance between 
% those points, we consider the fact that they are not in the
% same face.
for i=1:length(faces_idx)
    current_face = faces_coor_idx(i, :);
    % use interp1 in face
    
end

% order the points
orderedPointsCloud = myTsp(pointsCloud);
end