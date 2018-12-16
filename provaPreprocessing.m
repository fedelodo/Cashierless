function final = provaPreprocessing(img)
    imgRGB = im2double(imread(img));
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
end