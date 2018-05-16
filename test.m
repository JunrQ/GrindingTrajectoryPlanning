clc
clear
tic

%% add pth
addpath . ./utils/ ./pose/ ./traj/ ./collision_detection/

%% read target model, stl
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");

%% clusters
clusters = divideIntoFaces(v, f ,n);

% DON'T DO THIS
% Remove cluster that has negative z
% if 0
%     [~, cluster_num] = size(clusters);
%     newClusters = {};
%     tmp = 1;
%     for i=1:cluster_num
%         tmpPathIdx = clusters{i};
%         if mean(n(tmpPathIdx), 3) > 0
%             continue
%         end
%         newClusters{tmp} = tmpPathIdx;
%         tmp = tmp + 1;
%     end
%     clusters = newClusters;
% end
%

%% get path and normal vectors
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
normalVecs = n(pointsPathIdx, :);
normalVecsM = modifyNormalVec(normalVecs);

%% connect different clusters
[Ts, conInfo] = connectPaths(pointsPath, normalVecsM, clustersIdx);

%% get arm robot model and do inverse mech
[myRobot, q0, speed_limit, qlimit] = getRobotModel();
qs = Ts2q(myRobot, q0, 2, Ts, conInfo);
array2txt(qs, '2018-5-16_t2');

toc
% disp(['Running time: ',num2str(toc)]);