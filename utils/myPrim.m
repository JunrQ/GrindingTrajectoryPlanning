%MYPRIMFORLINES
%
% reordered = myPrimForLines(lines) prim for connect lines, this is very simple implementation.
%
%Author::
% - JunrZhou

function reordered = myPrim(lines)
% chose a line randomly
[m, ~] = size(lines);
reordered = zeros(m, 1);
visited = zeros(m, 1);
visited(1) = 1;
minIdx = 1;
% travser
for i = 2:m
    minLength = realmax;
    for j = 1:m
        % if considered, skip it
        if (abs(visited(j) - 1) < 1e-4)
            continue
        end
        tmp_dist = norm(lines(j, 4:6) - lines(j, 1:3));
        if tmp_dist < minLength
            minIdx = j;
            minLength = tmp_dist;
        end
    end
    visited(minIdx) = 1;
    reordered(i) = minIdx;
end
end

