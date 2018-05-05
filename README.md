# 

## 1. Get the target from \*.stl
Run the following scripts, this will return v, f, n.
`[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl")`

## 2. Get the robot arm in SerielLink model.
The following code will return `robot` as robot arm model.
`robot, q0, speed_limit, qlimit = getRobotModel()`

## 3. Get the path
### 3.1 Divide the whole stl model into individual faces
Divide into small faces will need less memory space, but also make the path
not global-optimal. So, the path will be generated according to different
faces.
