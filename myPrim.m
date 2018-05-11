%MYPRIMFORLINES
% prim for connect lines
%
function [reordered, r_norms] = myPrimForLines(lines)
% chose a line randomly
[m, n] = size(lines);

considered_l_idx = zeros(1, m);

% find the max z as start point
[~, tmp_i] = max(lines(:, [3 6]));
% root = ceil(rand() * m);
root = max(tmp_i);

cur_line_idx = root;

% add the first line
cur_line = lines(cur_line_idx, :);
reordered = lines(cur_line_idx, :);
r_norms = norms(cur_line_idx, :);
considered_l_idx(cur_line_idx) = 1;

% travser
for i = 1:(m-1)
    % which side
    side_indi = zeros(1, m);
    length_indi = ones(1, m) * 2147483647;
    
    for j = 1:m
        % if considered, skip it
        if considered_l_idx(j) == 1
            continue
        end
        tar_line = lines(j, :);
        tmp_dist = [norm(cur_line(4:6) - tar_line(1:3)),...
                    norm(cur_line(4:6) - tar_line(4:6))];
        
        [tmp_min, tmp_min_idx] = min(tmp_dist);
        side_indi(j) = tmp_min_idx;
        length_indi(j) = tmp_min;

    end
    % connect one
    [~, tmp_min_idx] = min(length_indi);
    % see which side
    side_num = side_indi(tmp_min_idx);
    % corrs to tmp_dist
    if side_num == 2
        cur_line = [lines(tmp_min_idx, 4:6), lines(tmp_min_idx, 1:3)];
    else
        cur_line = lines(tmp_min_idx, :);
    end
    reordered = [reordered; cur_line];
    r_norms = [r_norms; norms(tmp_min_idx, :)];
    cur_line_idx = tmp_min_idx;
    considered_l_idx(cur_line_idx) = 1;
end


end

