%MYINVERSE given points along path, return inverse solution.
%
% poseAlongPath = myInverse(robot, q, T, alpha, tol, iter_steps)
%
% - robot, SerielLink
% - q, initial q
% - T, target
% - alpha, step length
% - tol, tolerance of every degree freedom

% Author::
% - JunrZhou

function q_result = myInverse(robot, q, T, alpha, tol, iter_steps)
%% default parameters
if nargin < 4
    alpha = 1e-3;
end

if nargin < 5
    tol = 1e-7 * zeros(1, 6);
end

if nargin < 6
    iter_steps = 1e3;
end

%% Iterative
for i = 1:iter_steps
    Tq = robot.fkine(q');
    e(1:3) = transl(T - Tq);
    Rq = t2r(Tq);
    [th, n] = tr2angvec(Rq' * t2r(T));
    e(3:6) = th * n;
    
    % see if satified
    if ~any(abs(e) < tol) > 0
        break
    end
    
    J = robot.jacob0(q);
    
    dq = J' * e;
    dq = alpha * dq;
    
    q = q + dq';
end
if i == iter_steps
    q_result = [];
else
    q_result = q;
end
end