clearvars;
close all;

imgPath = "images/biscuits/thqsx.png";

%lettura immagine  
imgRGB = im2double(imread(imgPath));
imgG = rgb2gray(imgRGB);

%unsharp masking
imgGauss = imgaussfilt(imgG, 50);
imgSharp = (imgG - imgGauss) + imgG;

%calcolo edge
edgeImg = edge(imgSharp,'canny');
p = stdfilt(imgSharp);
p = imgaussfilt(imgG, 4);
%p = p - 0.06;
%p = imbinarize(p, 'adaptive');
%p = edge(p, 'canny');
%p = imdilate(p, strel('disk',10));
%p = imfill(p, 'holes');
%p = imerode(p, strel('disk', 25));
%p = imdilate(p, strel('disk',20));
labels = reshape(labels, out.nt_rows, out.nt_cols);

figure, 
imagesc(labels),axis image,colorbar,title("labels"),

%close and fill edges
dilatedEdges = imdilate(edgeImg, strel('disk',10));
filledEdges = imfill(dilatedEdges, 'holes');

%eliminazione bordi spuri
mask = imerode(filledEdges,strel('disk',30));
mask = imdilate(mask, strel('disk',30));

final = imgRGB .* mask;
  
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
