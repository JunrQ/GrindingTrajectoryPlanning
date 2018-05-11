mex myTraverser.cpp
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
clusters = divideIntoFaces(v, f ,n);
[pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{1}, v, f, n, 0.5);
[orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, 0);