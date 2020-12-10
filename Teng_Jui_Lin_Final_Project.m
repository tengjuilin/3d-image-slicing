% Teng-Jui Lin
% BIOEN 217
% 8 Dec 2020
% Final Project
clear; clc; close all

%% `obliqueslice2d` demo
clear; clc; close all

img = rgb2gray(imread('cell.jpg'));
point1 = [120, 15];
point2 = [10, 100];

oblique_slice = obliqueslice2d(img, point1, point2);
imshow(oblique_slice, 'InitialMagnification', 2000)
imwrite(oblique_slice, '3d-0.jpg')


%% `obliqueslice3d` demo
clear; clc; close all
load mri
MRI = squeeze(D);
point = [50; 50; 12];
normal = [0; 0; 1];
oblique_slice = obliqueslice3d(MRI, point, normal);
imshow(oblique_slice, map)
imwrite(oblique_slice, 'mri-0.jpg')

MRI_montage = montage(MRI, map)
saveas(MRI_montage, 'mri-1.jpg')

point = [50; 50; 12];
normal = [1; 1; 1];
oblique_slice = obliqueslice3d(MRI, point, normal);
imshow(oblique_slice, map)
imwrite(oblique_slice, 'mri-2.jpg')

point = [50; 50; 12];
normal = [1; 1; 1];
oblique_slice = obliqueslice3d(MRI, point, normal);
imshow(oblique_slice, map)
imwrite(oblique_slice, 'mri-3.jpg')
