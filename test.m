% tic
addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
normalVecs = n(pointsPathIdx, :);
normalVecsM = modifyNormalVec(normalVecs);
Ts = connectPaths(pointsPath, normalVecsM, clustersIdx);

% inverse
[myRobot, q0, speed_limit, qlimit] = getRobotModel();
qs = Ts2q(myRobot, q0, 2, Ts);


% toc
% disp(['Running time: ',num2str(toc)]);