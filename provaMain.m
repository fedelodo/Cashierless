clearvars;

imds = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');
imgs = imds.Files;

for i = 1:numel(imgs)
    out = gaborPreprocessing(imgs{i});
    imwrite(out,strrep(imgs{i}, "images", "gabored"));
end

%{

%close and fill edges
dilatedEdges = imdilate(edgeImg, strel('disk',10));
filledEdges = imfill(dilatedEdges, 'holes');

%eliminazione bordi spuri
mask = imerode(filledEdges,strel('disk',30));
mask = imdilate(mask, strel('disk',30));

final = imgRGB .* mask;
  

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
