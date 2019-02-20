clear;
clc;
close all;

dir_name = '..\data\Bicycle1-perfect\';
%im_left = imresize(imread([dir_name '218708.JPG']), 0.25);
%im_right = imresize(imread([dir_name '184010.JPG']), 0.25);
im_left = imresize(imread([dir_name 'im0.png']), 0.25);
im_right = imresize(imread([dir_name 'im1.png']), 0.25);

[label, label_num] = superpixels(im_left, 1000);

props = regionprops(label);
centroids = cat(1, props.Centroid);
areas = cat(1, props.Area);
boundingboxs = round(cat(1, props.BoundingBox));

centroids_est = [centroids, zeros(label_num, 2)];

for i = 1:label_num
    window = double(imcrop(im_left, boundingboxs(i, :)));
    
    [win_h, win_w, ~] = size(window);
    [height, width, ~] = size(im_right);
    
    epipole = boundingboxs(i, 2);
    simil = zeros(1, width - win_w + 1);
    
    for cols = 1 : (width - win_w + 1)
        tmp = double(imcrop(im_right, [cols-0.5, epipole-0.5, win_w-1, win_h-1]));
        
        simil(cols) = sum(sum(sum(((tmp - mean2(tmp)).*(window - mean2(window)))/(std2(tmp)*std2(window)))))/numel(window);
    end
    
    [match_score, match_idx] = max(simil);
    
    disparity = round(boundingboxs(i, 1)) - match_idx;
    centroids_est(i, 1) = centroids_est(i, 1) - disparity;
    centroids_est(i, 3) = match_score;
    centroids_est(i, 4) = disparity;
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

valid_idx = find((centroids_est(:, 3) > 0.707) & (centroids_est(:, 4) > 0));
valid_num = numel(valid_idx);
valid_set = zeros(valid_num, 5);
valid_set(:, 1) = centroids(valid_idx, 1);
valid_set(:, 2) = centroids(valid_idx, 2);
valid_set(:, 3) = centroids_est(valid_idx, 1);
valid_set(:, 4) = centroids_est(valid_idx, 2);
valid_set(:, 5) = centroids_est(valid_idx, 4);

[im_height, im_width, im_chan] = size(im_left);
disp_map = zeros(im_height, im_width);
for i = 1:valid_num
    cent_x = round(valid_set(i, 1));
    cent_y = round(valid_set(i, 2));
    disp_map(find(label == label(cent_y, cent_x))) = valid_set(i, 5);
end

simple_image = zeros(size(im_left),'like',im_left);
idx = label2idx(label);
num_row = size(im_left,1);
num_col = size(im_left,2);
for i = 1:label_num
    redIdx = idx{i};
    greenIdx = idx{i}+num_row*num_col;
    blueIdx = idx{i}+2*num_row*num_col;
    simple_image(redIdx) = mean(im_left(redIdx));
    simple_image(greenIdx) = mean(im_left(greenIdx));
    simple_image(blueIdx) = mean(im_left(blueIdx));
end

figure(1);
bd = boundarymask(label);
imshow(imoverlay(im_left, bd, 'cyan'), 'InitialMagnification', 67);
figure(2);
imshow(simple_image,'InitialMagnification',67)
figure(3);
subplot(1, 2, 1);
imshow(im_left);
hold on
plot(centroids(:,1),centroids(:,2), 'r*');
plot(valid_set(:,1),valid_set(:,2), 'b*');
hold off
subplot(1, 2, 2);
imshow(im_right);
hold on
plot(centroids_est(:,1),centroids_est(:,2), 'r*');
plot(valid_set(:,3),valid_set(:,4), 'b*');
hold off
figure(4);
imshow(disp_map/255);