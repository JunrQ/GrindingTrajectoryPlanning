# GrindingTrajectoryPlanning
All the code should be run under matlab console.
```matlab
addpath ./utils/
```

## 1. Get the target from \*.stl
Run the following scripts, this will return v, f, n.
```matlab
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
```

## 2. Get the robot arm in SerielLink model.
The following code will return `robot` as robot arm model.
```matlab
robot, q0, speed_limit, qlimit = getRobotModel();
```

## 3. Planning: get the path
### 3.1 Divide the whole stl model into individual faces
Divide into small faces will need less memory space, but also make the path
not global-optimal. So, the path will be generated according to different
faces.
```matlab
clusters = divideIntoFaces(v, f ,n); % clusters have shape [1, #clusters]
```

### 3.2 For each face cluster generate path
```matlab
% compile
mex generatePointsCloud.cpp % -largeArrayDims % This make mxSize size_t
mex myTraverser.cpp
[pointsPath, pointsPathIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
```
The function generatePath will run following code:
```matlab
[pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
[orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
```
which use graph traverse algorithm, see myTraverser.cpp for detail.



## 4. Planning: get the pose along the path
### 4.1 Add pose path
```matlab
addpath ./pose/
add path ./traj/
```

### 4.2 Get pose based on normal vectors


