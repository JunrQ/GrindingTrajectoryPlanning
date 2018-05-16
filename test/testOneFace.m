% tic
addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);

[pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{1}, v, f, n, 0.5);

normalVecs = n(pointsCloudFaceIdx, :);

normalVecsM = modifyNormalVec(normalVecs);

[tmpL, ~] = size(pointsCloud);
figure
for i=1:20:tmpL
    scatter3(pointsCloud(i, 1), pointsCloud(i, 2), pointsCloud(i, 3), 1,...
             [rand(), rand(), rand()]);
    hold on
    plot3([pointsCloud(i, 1), pointsCloud(i, 1) + normalVecsM(i, 1)],...
          [pointsCloud(i, 2), pointsCloud(i, 2) + normalVecsM(i, 2)],...
          [pointsCloud(i, 3), pointsCloud(i, 3) + normalVecsM(i, 3)],...
          'r');
    hold on
end



% inverse
% [myRobot, q0, speed_limit, qlimit] = getRobotModel();
% qs = Ts2q(myRobot, q0, 2, Ts);


% toc
% disp(['Running time: ',num2str(toc)]);