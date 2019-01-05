function final = provaPreprocessing2(imgPath)
    %lettura immagine  
    imgRGB = im2double(imread(imgPath));

    %unsharp masking
    gaussImg = imgaussfilt(imgRGB,5);

    %calcolo edge
    edgeR = edge(gaussImg(:,:,1),'canny');
    edgeG = edge(gaussImg(:,:,2),'canny');
    edgeB = edge(gaussImg(:,:,3),'canny');
    edgeImg = edgeR | edgeG | edgeB;
    
    %close and fill edges
    dilatedEdges = imdilate(edgeImg, strel('disk',5));
    filledEdges = imfill(dilatedEdges, 'holes');

    %eliminazione bordi spuri
    mask = imerode(filledEdges,strel('disk',40));
    mask = imdilate(mask, strel('disk',40));
    
    final = imgRGB .* mask;
end