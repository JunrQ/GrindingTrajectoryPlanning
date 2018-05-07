%GENERATEPOINTSCLOUD generate points cloud
%
% [pointsCloud, pointsCloudFaceIdx, pointsCloudAdjPointsIdx] = generatePointsCloud(faces_idx, v, f, n, number_adjoint, adjoint_length);
%
% - pointsCloud [m, 3] matrix, each representes a point in 3D space
% - pointsCloudFaceIdx [m, 1] matrix, each represents face index of points in pointsCloud
% - pointsCloudAdjPointsIdx [m, n] matrix, each represents adjoint points index of points in pointsCloud
% - number_adjoint int, number of adjoint points
% - adjoint_length double, length of adjoint points.
%
% Authors::
% - Junr Zhou