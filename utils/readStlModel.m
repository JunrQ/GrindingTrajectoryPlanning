%READSTLMODEL read in a stl model, use func to do preprocess, then return v, f, n
%
% [v, f, n] = readStlModel(path, func, VARARGIN)
%
% - PATH, the file path of stl file, in my project, the path
%   is just '/Users/junr/Documents/Works/graduation-project/code/planning/123.stl'
% - v, vertices
% - f, faces
% - n, normals
% **Note:** see stlRead for detail.

function [v, f, n] = readStlModel(path, func)
assert(exist(path)>0, "ERROR: File %s don't exists", path);
if nargin < 2
    func = @preprocessStlVFN;
end
[v, f, n, name] = stlRead(path);
[v, f, n] = func(v, f, n);
end