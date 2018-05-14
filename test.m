[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
normalVecs = n(pointsPathIdx, :);
% ./pose/ and ./traj/ have to in matlab path

