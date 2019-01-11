clear all; 
close all;

imgRGB = im2double(imread("keys.jpg"));
grey = rgb2gray(imgRGB);
edgez = edge(grey, 'canny');

edgez = imdilate(edgez, strel('disk',5));
filled = imfill(edgez,'holes');
filled = imerode(filled, strel('disk',15));

labels = bwlabel(filled);

imagesc(labels), colorbar, axis image;

numLabels = max(labels,[], 'all');

stats = regionprops(labels,'boundingbox');

hold on;
x = stats.BoundingBox;
line([17.5,17.5+97], [266.5, 266.5+216], 'Color', 'r');
line([17.5,17.5+97], [266.5, 266.5], 'Color', 'r');
line([17.5,17.5], [266.5, 266.5+216], 'Color', 'r');
line([17.5+97,17.5+97], [266.5, 266.5+216], 'Color', 'r');
line([17.5,17.5+97], [266.5+216, 266.5+216], 'Color', 'r');