% Teng-Jui Lin
% BIOEN 217
% 8 Dec 2020
% Final Project

%% 2D slicing figures
% original img
img = rgb2gray(imread('cell.jpg'));
[xlen, ylen] = size(img);
imshow(img)
imwrite(img, '2d-1.jpg')

%%% demo point pairs
% point1 = [120; 15];
% point2 = [10; 100];
point1 = [120; 15];
point2 = [200; 100];
% point1 = [120; 200];
% point2 = [10; 100];
% point1 = [100; 200];
% point2 = [200; 100];
% point1 = [100; 15];
% point2 = [120; 200];
% point1 = [10; 100];
% point2 = [200; 120];
% point1 = [10; 100];
% point2 = [10; 120];
% point1 = [10; 100];
% point2 = [200; 100];
% point1 = [10; 10];
% point2 = [10; 10];

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
   error('Given two identical points. ') 
end

% slicing along x-/y-axis
if x1 == x2
    oblique_slice = img(:, x1);
end
if y1 == y2
    oblique_slice = img(y1, :);
end

% chracterize the oblique line
slope = (y2-y1) / (x2-x1);
angle = atand(slope);
y = @(x) slope*x - slope*x1 + y1;

% find the points intersecting the oblique line at img edge
yvals = y(1:xlen);
x_slice_range_vals = find(yvals > 0.5 & yvals < ylen-0.5);
y_slice_range_vals = yvals(x_slice_range_vals);
point1_edge = round([x_slice_range_vals(1); y_slice_range_vals(1)])
point2_edge = round([x_slice_range_vals(end); y_slice_range_vals(end)])

% magnify the designated points as white dots
box = 1;
img(y1-box:y1+box, x1-box:x1+box) = 255;
img(y2-box:y2+box, x2-box:x2+box) = 255;
imshow(img)
imwrite(img, '2d-2.jpg')

% rotate original img
rotated_img = imrotate(img, angle);
[rot_xlen, rot_ylen] = size(rotated_img);
figure
imshow(rotated_img)
imwrite(rotated_img, '2d-3.jpg')

% rotate the points at edge
R = @(theta) [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
rotated_point1_edge = round(R(-angle) * (point1_edge - [xlen/2; ylen/2]) + [rot_xlen/2; rot_ylen/2])
rotated_point2_edge = round(R(-angle) * (point2_edge - [xlen/2; ylen/2]) + [rot_xlen/2; rot_ylen/2])

% find oblique slice on rotated img
oblique_slice = rotated_img(rotated_point1_edge(2), rotated_point1_edge(1):rotated_point2_edge(1));
rotated_img(rotated_point1_edge(2), :) = 255;
imshow(rotated_img)
imwrite(rotated_img, '2d-4.jpg')

% oblique slice with reference point
figure
imshow(oblique_slice, 'InitialMagnification', 2000)
imwrite(oblique_slice, '2d-5.jpg')


%% 3D slicing figures
clear; clc; close all
% sample data
load mri
img = squeeze(D);
[xlen, ylen, zlen] = size(img);
sliceViewer(img)
title('MRI Slices')

% define coord planes
xy_plane_n = [0, 0, 1];
plane_angle = @(n1, n2) acosd(dot(n1, n2)/(norm(n1)*norm(n2)));

% plane params
point = [50, 50, 12];
normal = [1; 1; 1];
angle = plane_angle(normal, xy_plane_n);
v = cross(normal, xy_plane_n);

% rotating img
rot_img = imrotate3(img, angle, v);
[rot_xlen, rot_ylen, rot_zlen] = size(rot_img);

figure, sliceViewer(rot_img)
title('Rot. MRI Slices')

figure
vol_MRI = volshow(img, 'CameraPosition', [0 1 5], 'BackgroundColor', [0 0 0]);
figure
vol_rot_MRI = volshow(rot_img, 'CameraPosition', [0 1 5], 'BackgroundColor', [0 0 0]);


%% Extract cell data
clear; clc; close all
t = Tiff('cells.tif');

% get tiff data
first_img= read(t);
[height, width] = size(first_img);
num_img = 165;

% setup empty cells
cells = zeros(height, width, num_img);

for k = 1:num_img
    setDirectory(t, k);
    cells(:, :, k) = read(t);
end
cells = uint8((cells));


%% obliqueslice3d on cell volume
point = [250; 250; 50];
normal = [1; 1; 3];
[one_slice, stack] = obliqueslice3d(cells, point, normal);
imshow(one_slice)
figure, sliceViewer(stack)
imwrite(one_slice, 'cells-1.jpg')

% show as volume
volshow(cells, 'BackgroundColor', [0, 0, 0])
