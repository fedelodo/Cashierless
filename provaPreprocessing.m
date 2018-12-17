function final = provaPreprocessing(imgPath)
    %lettura immagine  
    imgRGB = im2double(imread(imgPath));
    imgG = rgb2gray(imgRGB);

    %unsharp masking
    imgGauss = imgaussfilt(imgG, 50);
    imgSharp = (imgG - imgGauss) + imgG;

    %calcolo edge
    edgeImg = edge(imgSharp,'canny');
    
    %close and fill edges
    dilatedEdges = imdilate(edgeImg, strel('disk',10));
    filledEdges = imfill(dilatedEdges, 'holes');

    %eliminazione bordi spuri
    mask = imerode(filledEdges,strel('disk',30));
    mask = imdilate(mask, strel('disk',30));
    
    
    final = imgRGB .* mask;
end