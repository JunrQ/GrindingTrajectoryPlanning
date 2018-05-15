a = -1 * ones(20, 1);
a = elementsUnion(a, 1, 2);
a = elementsUnion(a, 2, 3);
a = elementsUnion(a, 4, 3);
a = elementsUnion(a, 6, 3);
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