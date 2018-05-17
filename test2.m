% Differences from test.m
% 1. boarder gap between points
% 2. make start faster, see `qs = Ts2q(myRobot, q0, 2, Ts, conInfo, true);` for details

clc
clear
tic

%% add pth
addpath . ./utils/ ./pose/ ./traj/ ./collision_detection/

%% read target model, stl
% [v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/face_traj/gongjian.stl");

%% clusters
clusters = divideIntoFaces(v, f ,n);

%% get path and normal vectors
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 2, 0);
normalVecs = n(pointsPathIdx, :);
normalVecsM = modifyNormalVec(normalVecs);
%% after modify normal vectors, all the normal vectors points to inside
% and closer to z-
% so we will use normalVecs as original vectors, which points to outside.

%% connect different clusters
[Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx);

%% get arm robot model and do inverse mech
[myRobot, q0, speed_limit, qlimit] = getRobotModel();
qs = Ts2q(myRobot, q0, 2, Ts, conInfo, true);
array2txt(qs, '2018-5-17_t1');

% myRobot.plot(qs(:, 1:6))

toc
% disp(['Running time: ',num2str(toc)]);