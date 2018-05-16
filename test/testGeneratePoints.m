addpath ./utils/ ./pose/ ./traj/ ./collision_detection/

[v, f, n] = readStlModel("/Users/junr/Documents/Works/graduation-project/code/planning/123.stl");
[pointsCloud, pointsCloudFaceIdx] = generatePointsCloud([1], v, f, n, 0.5);

figure
scatter3(pointsCloud(:, 1), pointsCloud(:, 2), pointsCloud(:, 3), 1);
hold on

tmp = f(1, :);
tmpP = v(tmp, :);
scatter3(tmpP(:, 1), tmpP(:, 2), tmpP(:, 3), 10, [1, 0, 0]);
