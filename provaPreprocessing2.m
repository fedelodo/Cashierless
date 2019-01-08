function final = provaPreprocessing2(imgPath)
    %lettura immagine  
    imgRGB = im2double(imread(imgPath));

    %unsharp masking
    gaussImg = imgaussfilt(imgRGB,7);
    n = 10;

    %calcolo edge
    edgeR = edge(medfilt2(gaussImg(:,:,1), [n n]),'canny');
    edgeG = edge(medfilt2(gaussImg(:,:,2), [n n]),'canny');
    edgeB = edge(medfilt2(gaussImg(:,:,3), [n n]),'canny');
    edgeImg = edgeR | edgeG | edgeB ;
    
    %close and fill edges
    dilatedEdges = imdilate(edgeImg, strel('disk',5));
    filledEdges = imfill(dilatedEdges, 'holes');

    %eliminazione bordi spuri
    mask = imerode(filledEdges,strel('disk',40));
    mask = imdilate(mask, strel('disk',40));
    
    final = imgRGB .* mask;
end