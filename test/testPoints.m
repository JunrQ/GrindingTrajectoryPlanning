function testPlot0()
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);

figure
[~, m] = size(clusters);
for i=1:m
    tmpPoints = pointsPath(clustersIdx==i, :);

    scatter3(tmpPoints(:, 1), tmpPoints(:, 2), tmpPoints(:, 3), 1, [rand(), rand(), rand()]);
    hold on
end