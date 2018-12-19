function final = gaborPreprocessing(imgPath)
    %lettura immagine  
    imgRGB = im2double(imread(imgPath));
    imgRGB = imresize(imgRGB, 0.5);

    %gabor
    gaborImg = gaborFilter(imgRGB);

    mask = imbinarize(gaborImg);

    final = mask .* imgRGB;
    
end