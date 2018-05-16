# GrindingTrajectoryPlanning
All the code should be run under matlab console.
```matlab
addpath ./utils/ ./pose/ ./traj/ ./collision_detection/
mex ./utils/generatePointsCloud.cpp % -largeArrayDims % This make mxSize size_t
mex ./utils/myTraverser.cpp
```

## 1. Get the target from \*.stl
Run the following scripts, this will return v, f, n.
`readSTLModel` function have a parameter func, which is a function handle used for
preprocessing, the default is `preprocessStlVFN`, you can do some other preprocess
by change the function.
```matlab
[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
```

## 2. Get the robot arm in SerielLink model.
The following code will return `robot` as robot arm model.
```matlab
robot, q0, speed_limit, qlimit = getRobotModel();
```

## 3. Planning: get the path.
### 3.1 Divide the whole stl model into individual faces.
Divide into small faces will need less memory space, but also make the path
not global-optimal. So, the path will be generated according to different
faces.
```matlab
clusters = divideIntoFaces(v, f ,n); % clusters have shape [1, #clusters]
```

### 3.2 For each face cluster generate path.
```matlab
[pointsPath, pointsPathIdx] = generatePathFromClusters(clusters, v, f, n, 0.5, 0);
```
The function generatePath will run following code:
```matlab
[pointsCloud, pointsCloudFaceIdx] = generatePointsCloud(clusters{cluIdx}, v, f, n, gap);
[orderedPointsCloud, orderedPointsCloudIdx] = myTraverser(pointsCloud, pointsCloudFaceIdx, method);
```
which use graph traverse algorithm, see myTraverser.cpp for detail.



## 4. Planning: get the pose along the path.
### 4.1 Modify NormalVec.
Normal vectors generate before are path normal vectors. As for points, we need add some 
smoothness between different points in different faces.
And you can add more modification to make it fit your project, your robot by changing
the function.
```matlab
normalVecsM = modifyNormalVec(normalVecs);
```

### 4.2 Get pose based on normal vectors.
The `connectPaths` function transfer points and normal vectors into 
homogeneous transformation matrix.
TODO: according to their clustersIdx, add transition path.
```matlab
Ts = connectPaths(pointsPath, normalVecsM, clustersIdx);
```

### 4.3 Get joint space qs.
The `Ts2q` function transfer homogeneous transformation matrix into
joint space coordinates, qs, which is angle of six axis of the robot.
```matlab
qs = Ts2q(myRobot, q0, 2, Ts);
```
### 4.4 Save result.
Save result, name it.
```matlab
array2txt(qs, '2018-5-16_t1');
```