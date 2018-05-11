[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
pointsPath = generatePathFromClusters(clusters, v, f, n, 0.5, 0);