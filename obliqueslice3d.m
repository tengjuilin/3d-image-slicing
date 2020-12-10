function [oblique_slice, rot_img] = obliqueslice3d(img, point, normal)
% Returns a 2D matrix (grayscale image) that represents the oblique slice
% of 3D grayscale volumetric image data.

% argument check
[xlen, ylen, zlen] = size(img);
img_size = [xlen; ylen; zlen];
if ~all(point >= 1) || ~all(point <= img_size)
    error('coordinate of point out of bound.')
end
xy_plane_n = [0, 0, 1];
if isequal(normal, xy_plane_n) || isequal(normal', xy_plane_n)
    oblique_slice = img(:, :, point(3));
    return
end

% plane params
plane_angle = @(n1, n2) acosd(dot(n1, n2)/(norm(n1)*norm(n2)));
angle = plane_angle(normal, xy_plane_n);  % angle between xy-plane and user-defined plane
v = cross(normal, xy_plane_n);  % direction of the line intersecting xy-plane and user-defined plane
v = v/norm(v);  % find unit vector (required by rot. matrix R)

% rotating img
rot_img = imrotate3(img, angle, v);
[rot_xlen, rot_ylen, rot_zlen] = size(rot_img);

% rotating point
R3d = @(l, m, n, theta) [
    l*l*(1-cos(theta))+cos(theta), m*l*(1-cos(theta))-n*sin(theta), n*l*(1-cos(theta))+m*sin(theta)
    l*m*(1-cos(theta))+n*sin(theta), m*m*(1-cos(theta))+cos(theta), n*m*(1-cos(theta))-l*sin(theta)
    l*n*(1-cos(theta))-m*sin(theta), m*n*(1-cos(theta))+l*sin(theta), n*n*(1-cos(theta))+cos(theta)
    ];
R = @(v, theta) R3d(v(1), v(2), v(3), theta);
rot_point = R(v, angle) * (point - [xlen/2; ylen/2; zlen/2]) + [rot_xlen/2; rot_ylen/2; rot_zlen/2]

% get oblique slice on rotated img
oblique_slice = rot_img(:, :, round(rot_point(3)));
end

