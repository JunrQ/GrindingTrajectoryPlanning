function flag = pointFaceRela(cur_point, onePointOnFace, n)
tmp_vec = cur_point - onePointOnFace;
if (tmp_vec * n') > 0
    flag = 1;
else
    flag = 0;
end
end