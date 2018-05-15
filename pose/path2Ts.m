%PATH2TS Turn path into T, transformation matrix
%
% Ts = path2Ts(path, normals)

function Ts = path2Ts(path, normals)
Ts = {};
[path_num, ~] = size(path);

% first one
T1 = transl(path(1, 1:3));
tmp_l = normals(1, :);
tmp_l = tmp_l / norm(tmp_l);
tmp_count = find(tmp_l);
tmp_x = [(tmp_l(mod(tmp_count, 3) + 1) + tmp_l(mod(1 + tmp_count, 3) + 1)) / (-tmp_l(tmp_count)), 1, 1];
tmp_x = tmp_x / norm(tmp_x);
tmp_y = cross(tmp_l, tmp_x);
T1(1:3, 1) = tmp_x;
T1(1:3, 2) = tmp_y;
T1(1:3, 3) = tmp_l;
Ts{1, 1} = T1;

for i = 1:(tmp_size-1)
    % base on two normal vector of adjacent faces, get the pose's angles
    % tmp = normals(i, 1:3) + normals(i, 4:6);
    % if tmp(1) < 0
    %     tmp = -tmp; % make it up arrows to down
    % end

    tmp_l = normals(i+1, :);
    T2 = transl(path(i, 4:6));
    tmp_l = tmp_l / norm(tmp_l);
    tmp_count = find(tmp_l);
    tmp_x = [(tmp_l(mod(tmp_count, 3) + 1) + tmp_l(mod(1 + tmp_count, 3) + 1)) / (-tmp_l(tmp_count)), 1, 1];
    tmp_x = tmp_x / norm(tmp_x);
    tmp_y = cross(tmp_l, tmp_x);
    T2(1:3, 1) = tmp_x;
    T2(1:3, 2) = tmp_y;
    T2(1:3, 3) = tmp_l;
    
    Ts{i, 2} = T2;
    Ts{i, 3} = norm(path(i, 1:3) - path(i, 4:6)); % the length
    Ts{i, 4} = path(i, 7); % whether on the target
    
    T1 = transl(path(i+1, 1:3));
    T1(1:3, 1:3) = T2(1:3, 1:3);
    Ts{i+1, 1} = T1;
end

% the last point
T2 = transl(path(tmp_size, 4:6));
T2(1:3, 1:3) = T1(1:3, 1:3);
Ts{tmp_size, 2} = T2;
Ts{tmp_size, 3} = norm(path(tmp_size, 1:3) - path(tmp_size, 4:6));
Ts{i, 4} = path(tmp_size, 7);

end