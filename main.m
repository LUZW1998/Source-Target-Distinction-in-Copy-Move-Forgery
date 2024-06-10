clear
clc
close all
addpath(genpath('function'))


name = '001';
image_path = ['.\Forged Images\',name,'_F.png'];
gt_path = ['.\Black and White Ground-Truth\',name,'_B.png'];

% image_path = 'E:\ImageDataset\micc_f600_test\forgery\wood_carvings.png';
% gt_path = 'E:\ImageDataset\micc_f600_test\ground-true\wood_carvings_gt.png';


img_rgb = imread(image_path);
img = rgb2gray(img_rgb);
img_gt = imread(gt_path);


siz1 = 8;
T = 4;


[result,JSD1,JSD2] = region_distinguishment(img,siz1,T,img_gt);
figure;
imshow(result)