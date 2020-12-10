function [oblique_slice] = obliqueslice2d(img, point1, point2)
% Returns a vector that represents the oblique slice of a
% 2D grayscale image.

% aliasing coordinates
x1 = point1(1);
x2 = point2(1);
y1 = point1(2);
y2 = point2(2);

% argument check
if length(size(img)) > 2
    error('Support only gray-scale 2D image.')
end
if x1 == x2 && y1 == y2
   error('Given two identical points.') 
end

% slicing along x-/y-axis
if x1 == x2
    oblique_slice = img(:, x1);
    return
end
if y1 == y2
    oblique_slice = img(y1, :);
    return
end

% chracterize the oblique line
slope = (y2-y1) / (x2-x1);
angle = atand(slope);
y = @(x) slope*x - slope*x1 + y1;

% find the points intersecting the oblique line at img edge
[xlen, ylen] = size(img);
yvals = y(1:xlen);
x_slice_range_vals = find(yvals > 0.5 & yvals < ylen-0.5);
y_slice_range_vals = yvals(x_slice_range_vals);
point1_edge = round([x_slice_range_vals(1); y_slice_range_vals(1)]);
point2_edge = round([x_slice_range_vals(end); y_slice_range_vals(end)]);

% rotate the original img
rotated_img = imrotate(img, angle);
[rot_xlen, rot_ylen] = size(rotated_img);

% rotate the points at edge
R = @(theta) [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
rotated_point1_edge = round(R(-angle) * (point1_edge - [xlen/2; ylen/2]) + [rot_xlen/2; rot_ylen/2]);
rotated_point2_edge = round(R(-angle) * (point2_edge - [xlen/2; ylen/2]) + [rot_xlen/2; rot_ylen/2]);

% find oblique slice on rotated img
oblique_slice = rotated_img(rotated_point1_edge(2), rotated_point1_edge(1):rotated_point2_edge(1));
end

