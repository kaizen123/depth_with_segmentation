clear;
clc;
close all;

dir_name = '..\data\room2\';
sp_left = imread([dir_name 'left.jpg']);
sp_right = imread([dir_name 'right.jpg']);
cube_left = equi2cubic(sp_left, 1000);
cube_right = equi2cubic(sp_right, 1000);
im_left = cube_left{1};
im_right = cube_right{1};
[im_left, im_right] = rectify_stereo(im_left, im_right);
%im_left = imresize(imread([dir_name 'im0.png']), 0.25);
%im_right = imresize(imread([dir_name 'im1.png']), 0.25);

%{
names = {'Front Face', 'Right Face', 'Back Face', 'Left Face', ...
    'Top Face', 'Bottom Face'};
figure(1);
for idx = 1 : numel(names)
    % Show image in figure and name the face
    subplot(2,3,idx);
    imshow(cube_left{idx});
    title(names{idx});
end
figure(2);
for idx = 1 : numel(names)
    % Show image in figure and name the face
    subplot(2,3,idx);
    imshow(cube_right{idx});
    title(names{idx});
end

disparityRange = [-6 10];
disparityMap = disparity(rgb2gray(im_left),rgb2gray(im_right),'BlockSize',...
    15,'DisparityRange',disparityRange);
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar
%}
[disp_map_left, label_left, label_num_left, centroids_left, centroids_est_left, valid_set_left] ...
= superpixel_disparity_left(im_left, im_right);

[disp_map_right, label_right, label_num_right, centroids_right, centroids_est_right, valid_set_right] ...
= superpixel_disparity_right(im_left, im_right);

figure(1);
bd = boundarymask(label_left);
imshow(imoverlay(im_left, bd, 'cyan'), 'InitialMagnification', 67);

figure(2);
simple_image = zeros(size(im_left),'like',im_left);
idx = label2idx(label_left);
num_row = size(im_left,1);
num_col = size(im_left,2);
for i = 1:label_num_left
    redIdx = idx{i};
    greenIdx = idx{i}+num_row*num_col;
    blueIdx = idx{i}+2*num_row*num_col;
    simple_image(redIdx) = mean(im_left(redIdx));
    simple_image(greenIdx) = mean(im_left(greenIdx));
    simple_image(blueIdx) = mean(im_left(blueIdx));
end
imshow(simple_image,'InitialMagnification',67)

figure(3);
subplot(1, 2, 1);
imshow(im_left);
hold on
plot(centroids_left(:,1),centroids_left(:,2), 'r*');
plot(valid_set_left(:,1),valid_set_left(:,2), 'b*');
hold off
subplot(1, 2, 2);
imshow(im_right);
hold on
plot(centroids_est_left(:,1),centroids_est_left(:,2), 'r*');
plot(valid_set_left(:,3),valid_set_left(:,4), 'b*');
hold off

figure(4);
imshow(disp_map_left/255);

figure(5);
bd = boundarymask(label_right);
imshow(imoverlay(im_right, bd, 'cyan'), 'InitialMagnification', 67);

figure(6);
simple_image = zeros(size(im_right),'like',im_right);
idx = label2idx(label_right);
num_row = size(im_right,1);
num_col = size(im_right,2);
for i = 1:label_num_right
    redIdx = idx{i};
    greenIdx = idx{i}+num_row*num_col;
    blueIdx = idx{i}+2*num_row*num_col;
    simple_image(redIdx) = mean(im_right(redIdx));
    simple_image(greenIdx) = mean(im_right(greenIdx));
    simple_image(blueIdx) = mean(im_right(blueIdx));
end
imshow(simple_image,'InitialMagnification',67)

figure(7);
subplot(1, 2, 1);
imshow(im_right);
hold on
plot(centroids_right(:,1),centroids_right(:,2), 'r*');
plot(valid_set_right(:,1),valid_set_right(:,2), 'b*');
hold off
subplot(1, 2, 2);
imshow(im_left);
hold on
plot(centroids_est_right(:,1),centroids_est_right(:,2), 'r*');
plot(valid_set_right(:,3),valid_set_right(:,4), 'b*');
hold off

figure(8);
imshow(disp_map_right/255);