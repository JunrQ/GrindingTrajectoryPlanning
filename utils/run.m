function [myRobot, qs] = run(stlPath)
[v, f, n] = readStlModel(stlPath);
clusters = divideIntoFaces(v, f ,n);
%% get path and normal vectors
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 1, 0);
normalVecs = n(pointsPathIdx, :);
normalVecsM = modifyNormalVec(normalVecs, 50);
%% connect different clusters
detector = CollisionDetector(stlPath);
% [Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx, detector);
[Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx, detector);
[myRobot, q0, speed_limit, qlimit] = getRobotModel();
qs = Ts2q(myRobot, q0, 2, Ts, conInfo, true);
qs(:, 6) = 0;