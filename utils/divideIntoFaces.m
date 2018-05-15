%DIVIDEINTOFACES divide whole faces into clustered faces
%
% clusters = divideIntoFaces(v, f, n) will return a cell
% array, each element represents a cluster. The index of
% face will be stored in the cell array.
%
% **disjoint set** 
% **Algorithm**:
%   traverse

function clusters = divideIntoFaces(v, f, n)
clusters = {};
tmp_cls = 0;
[face_num, ~] = size(f);
% 1 means processed, 0 means not.
face_processed = zeros(face_num, 1);
% store the class for every face, use disjoint set.
disjoint_set_array = -1 * ones(face_num, 1);
while 1
    % if all processed, break the loop
    if all(face_processed>0.1) % >0.1 to avoid float problem
        break
    end
    % traverse all the faces
    for i=1:face_num
        if face_processed(i) > 0.1
            continue
        end
        tmp_cls = tmp_cls + 1;
        clusters{tmp_cls} = [i];
        face_processed(i) = 1.0;
        % traverse all other faces, if connected to this path
        % and the angle of the two faces is less than an
        % threshold, the two faces are in the same set.
        for j=(i+1):face_num
            if face_processed(j) > 0.1
                continue
            end
            % first, see if connected
            % if two faces have two points in common, they are connected
            for tmp_face_cluster_idx=1:length(clusters{tmp_cls})
                tmp_face_idx = clusters{tmp_cls}(tmp_face_cluster_idx);
                tmp_l = intersect(f(tmp_face_idx, :), f(j, :));
                if length(tmp_l) == 2 % have one line in common, connected
                    n1 = n(tmp_face_idx, :);
                    n2 = n(j, :);
                    if norm2angle(n1, n2) < 90
                        disjoint_set_array = elementsUnion(disjoint_set_array, i, j);
                        face_processed(j) = 1.0;
                        clusters{tmp_cls} = [clusters{tmp_cls}, j];
                        % break, in case other face in the cluster is connected to j
                        break;
                    end
                end
            end
        end
    end
end
end


function [cls_idx, arr] = find(arr, idx)
%FIND disjoint find op, given index of element
if(arr(idx) < 0) % if root, return indx
    cls_idx = idx;
else
    cls_idx = find(arr, arr(idx)); % find(arr, parent)
    arr(idx) = cls_idx; % path compress, make idx's parent point to cls_idx
end
end

function arr = elementsUnion(arr, a, b)
%ELEMENTSUNION disjoint union op given elements a, b
%
% union(arr, a, b)
[root1, arr] = find(arr, a); % find root of a
[root2, arr] = find(arr, b); % find root of b

if(root1 == root2)
    return
else
    if arr(root2) < arr(root1) % root1 is deeper set
        arr(root1) = root2;
    else 
        if arr(root1) == arr(root2)
            arr(root1) = arr(root1) - 1;
        end
        arr(root2) = root1;
    end
end
end