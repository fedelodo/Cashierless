clearvars;
close all;

imgPath = "images/biscuits/w4vsw.png";

imgRGB = im2double(imread(imgPath));

figure(4)
imshow(imgRGB);

gaussImg = imgaussfilt(imgRGB,7);


figure(6)
imshow(gaussImg);

n = 10;

edgeR = edge(medfilt2(gaussImg(:,:,1), [n n]),'canny');
edgeG = edge(medfilt2(gaussImg(:,:,2), [n n]),'canny');
edgeB = edge(medfilt2(gaussImg(:,:,3), [n n]),'canny');
edgeImg = edgeR | edgeG | edgeB ;
figure(1),
imshow(edgeImg);

%close and fill edges
dilatedEdges = imdilate(edgeImg, strel('disk',5));
filledEdges = imfill(dilatedEdges, 'holes');

figure(2),
imshow(dilatedEdges);

%eliminazione bordi spuri
mask = imerode(filledEdges,strel('disk',30));
mask = imdilate(mask, strel('disk',30));

final = imgRGB .* mask;

figure(3),
imshow(final);
%{
figure(1),
subplot(1,3,1), imshow(imgG),
subplot(1,3,2), imshow(imgGauss),
subplot(1,3,3), imshow(imgSharp);

figure(2),
subplot(1,3,1), imshow(edgeImg),
subplot(1,3,2), imshow(dilatedEdges),
subplot(1,3,3), imshow(mask);

figure(3),
subplot(1,2,1), imshow(final);
%}
