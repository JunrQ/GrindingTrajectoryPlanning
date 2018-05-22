addpath . ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 1, 0);

figure
[~, m] = size(clusters);
for i=2:2
    tmpPoints = pointsPath(clustersIdx==i, :);

    scatter3(tmpPoints(:, 1), tmpPoints(:, 2), tmpPoints(:, 3), 1, [rand(), rand(), rand()]);
    hold on
end