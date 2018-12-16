clear;
close all;

imgRGB = im2double(imread("images/weev6.png"));
imgG = rgb2gray(imgRGB);

se = strel('disk',10);

imgGauss = imgaussfilt(imgG, 50);
imgSharp = (imgG - imgGauss) + imgG;


otsuThreshold = graythresh(imgG);
segmImg = im2bw(imgG,otsuThreshold);

edgeImg = edge(imgSharp,'canny');
dilated = imdilate(edgeImg, se);
dilatedFill = imfill(dilated, 'holes');


final = imerode(dilatedFill,strel('disk',30));
final = imdilate(final, strel('disk',30));


figure(1),
subplot(1,3,1), imshow(imgG),
subplot(1,3,2), imshow(imgGauss),
subplot(1,3,3), imshow(imgSharp);

figure(2),
subplot(1,3,1), imshow(edgeImg),
subplot(1,3,2), imshow(dilatedFill),
subplot(1,3,3), imshow(final);

figure(3),
subplot(1,2,1), imshow(final .* imgG),
subplot(1,2,2), imshow(final .* imgRGB);