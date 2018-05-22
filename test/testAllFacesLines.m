addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 1, 0);

normalVecs = n(pointsPathIdx, :);

normalVecsM = modifyNormalVec(normalVecs);

[tmpL, ~] = size(pointsPath);
figure
for i=1:1000
    plot3(pointsPath(:, 1), pointsPath(:, 2), pointsPath(:, 3),...
          'r');
    hold on
end