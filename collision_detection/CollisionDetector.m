%
%

classdef CollisionDetector
properties
    stlPath = "/Users/junr/Documents/Works/graduation-project/code/face_traj/gongjian.stl";
    v
    f
    n
    centerP
end

methods
    function cd = CollisionDetector(stlPath)
        if nargin = 1
            cd.stlPath = "/Users/junr/Documents/Works/graduation-project/code/face_traj/gongjian.stl";
        end
        [cd.v, cd.f, cd.n] = readStlModel(cd.stlPath, @connectPathPreprocessSTLVFN);
        cd.centerP = getCenterPointsOfFace(cd.v, cd.f);
    end % CollisionDetector
end

methods
    function [nums, points] = traj(obj, lastP, curP, lastN, curN)
        if nargin == 4
            while 1
                
            end
        end

            
    end
end
    
end