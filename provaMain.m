clearvars;

imgPath = "images/chocolate/an34u.png";

imgRGB = im2double(imread(imgPath));

%p = stdfilt(imgRGB);

gaussImg = imgaussfilt(imgRGB,10);

edgeR = edge(gaussImg(:,:,1),'canny');
edgeG = edge(gaussImg(:,:,2),'canny');
edgeB = edge(gaussImg(:,:,3),'canny');
edgeImg = edgeR | edgeG | edgeB;
figure(1),
imshow(edgeImg);

%close and fill edges
dilatedEdges = imdilate(edgeImg, strel('disk',5));
filledEdges = imfill(dilatedEdges, 'holes');

figure,imshow(filledEdges);

%eliminazione bordi spuri
mask = imerode(filledEdges,strel('disk',20));
mask = imdilate(mask, strel('disk',20));

final = imgRGB .* mask;

figure(2),
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
