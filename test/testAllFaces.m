addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 1, 0);

normalVecs = n(pointsPathIdx, :);

normalVecsM = modifyNormalVec(normalVecs);

[tmpL, ~] = size(pointsPath);
figure
for i=1:10:tmpL
    scatter3(pointsPath(i, 1), pointsPath(i, 2), pointsPath(i, 3), 1,...
             [rand(), rand(), rand()]);
    hold on
    plot3([pointsPath(i, 1), pointsPath(i, 1) + normalVecsM(i, 1)],...
          [pointsPath(i, 2), pointsPath(i, 2) + normalVecsM(i, 2)],...
          [pointsPath(i, 3), pointsPath(i, 3) + normalVecsM(i, 3)],...
          'r');
    hold on
end