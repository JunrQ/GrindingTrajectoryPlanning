function [v, target_face, target_normal] = connectPathPreprocessSTLVFN(v, f, n)
%% move, translation
v = v + [-300, 0, 0];
%% get the faces with y>120, get their area and normal
% the stl file is saved as patch_x_y.bmp, and the target has y>120
target_face_idx = [];
[faces_num, ~] = size(f); % number of faces
for i = 1:faces_num
    if ~any(v(f(i, :), 3) < 110)
        target_face_idx = [target_face_idx; i];
    end
    
end
target_normal = n(target_face_idx, :); % normal vector
target_face = f(target_face_idx, :);
end