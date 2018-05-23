%GETROBOTMODEL return SerielLink object of the robot and other
%information
%
% robot, q0, speed_limit, qlimit = getRobotModel()
%
% - robot, SerielLink object
% - q0, initial position
% - speed_limit, speed limit of axis
% - qlimit, limitation of axis, unit: rad
function [robot, q0, speed_limit, qlimit] = getRobotModel()
%% Build DH model
% base
% z-672.5, 0, 0
% q0 = [pi/2, 0, -pi/2, pi/2, pi/2, 0];

L(1) = Link('revolute', 'd', 0, 'a', -20, 'alpha', pi/2);
L(2) = Link('revolute', 'd', 0, 'a', 260, 'alpha', 0, 'offset', pi/2);
L(3) = Link('revolute', 'd', 0, 'a', 20, 'alpha', -pi/2);
L(4) = Link('revolute', 'd', 280, 'a',0, 'alpha', pi/2);
L(5) = Link('revolute', 'd', 0, 'a', 0, 'alpha', -pi/2);
L(6) = Link('revolute', 'd', 419.5, 'a', 0, 'alpha', 0);
q0 = [0 0 0 0 0 0];
robot = SerialLink(L, 'name', 'LR4-R560');

% L(1) = Link('revolute', 'd', 345, 'a', 20, 'alpha', pi/2);
% L(2) = Link('revolute', 'd', 0, 'a', 260, 'alpha', 0, 'offset', pi/2);
% L(3) = Link('revolute', 'd', 0, 'a', 20, 'alpha', pi/2);
% L(4) = Link('revolute', 'd', 280, 'a',0, 'alpha', -pi/2);
% L(5) = Link('revolute', 'd', 0, 'a', 0, 'alpha', pi/2);
% L(6) = Link('revolute', 'd', 419.5, 'a', 0, 'alpha', 0);
% q0 = [0 0 0 0 0 0];
% robot = SerialLink(L, 'name', 'LR4-R560');

%% Tool, base
% robot.tool = transl(0, 0, 352);
robot.base = transl(0, 0, 345);

%% Some other information
speed_limit = [416, 416, 462, 560, 560, 740] / 180 * pi;
qlimit = [-170, 170; -143, 87; -53, 217; -200, 200; -125, 125; -360, 360] / 180 * pi;
% robot.plot(q0)
end