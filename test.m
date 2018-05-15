tic
addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsPath, pointsPathIdx, clustersIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
normalVecs = n(pointsPathIdx, :);
Ts = connectPaths(pointsPath, normalVecs, clustersIdx);



toc
% disp(['Running time: ',num2str(toc)]);