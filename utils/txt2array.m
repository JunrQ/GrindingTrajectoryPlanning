function array = txt2array(filepath)
fid = fopen(filepath, 'r');
while ~feof(fid)
    tl = fgetl(fid)
    
end

fclose(fid);
end