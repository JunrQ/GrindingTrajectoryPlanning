%ARRAY2TXT save 2D array as txt, one line in txt for one row in array
%
% array2txt(array, filename, format)
%
% - array, must be double matrix
% - filename, file with suffix '.txt'

function array2D2txt(array, filename, format)
if nargin < 3
    format = 6;
end
fid = fopen([filename, '_f', num2str(format), '.txt'], 'w');
[m, n] = size(array);
for j = 1:m
    for z = 1:n
        if z == n
            fprintf(fid, ['%10.', num2str(format), 'f\n'], array(j, z));
        else
            fprintf(fid, ['%10.', num2str(format), 'f\t'], array(j, z));
        end
    end
end
fclose(fid);
end