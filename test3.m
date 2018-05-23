% Differences from test2.m
% 1. add detector

clc
clear
tic

%% add pth
addpath . ./utils/ ./pose/ ./traj/ ./collision_detection/

%% read target model, stl
stlPath = "/Users/junr/Documents/Works/graduation-project/code/planning/123.stl";
% stlPath = "/Users/junr/Documents/Works/graduation-project/code/face_traj/gongjian.stl";
[v, f, n] = readStlModel(stlPath);

%% clusters
clusters = divideIntoFaces(v, f ,n);

%% get path and normal vectors
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 1, 0);
normalVecs = n(pointsPathIdx, :);
normalVecsM = modifyNormalVec(normalVecs, 50);
%% after modify normal vectors, all the normal vectors points to inside
% and closer to z-
% so we will use normalVecs as original vectors, which points to outside.

%% connect different clusters
detector = CollisionDetector(stlPath);
% [Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx, detector);
[Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx, detector);

%% get arm robot model and do inverse mech
[myRobot, q0, speed_limit, qlimit] = getRobotModel();
qs = Ts2q(myRobot, q0, 2, Ts, conInfo, true);
qs(:, 6) = 0;
% qsM = modifyQ(qs, 1);
array2txt(qsM, '2018-5-23_t2');

% myRobot.plot(qs(:, 1:6))

toc
% disp(['Running time: ',num2str(toc)]);