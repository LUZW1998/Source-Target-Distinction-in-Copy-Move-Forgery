clear
clc
close all
addpath(genpath('function'))


name = '002';
image_path = ['image\Forged Images\',name,'_F.png'];
gt_path = ['image\Ground True\',name,'_B.png'];


img_rgb = imread(image_path);
img = rgb2gray(img_rgb);
img_gt = imread(gt_path);


siz1 = 8;
T = 4;


[result,JSD1,JSD2] = region_distinguishment(img,siz1,T,img_gt);
figure;
imshow(result)
fprintf('Red represents the target region \n')
