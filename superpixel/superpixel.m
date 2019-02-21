clear;
clc;
close all;

dir_name = '..\data\Bicycle1-perfect\';
%im_left = imresize(imread([dir_name '218708.JPG']), 0.25);
%im_right = imresize(imread([dir_name '184010.JPG']), 0.25);
im_left = imresize(imread([dir_name 'im0.png']), 0.25);
im_right = imresize(imread([dir_name 'im1.png']), 0.25);

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