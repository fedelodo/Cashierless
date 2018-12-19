function out_gabor = gaborFilter(imgRGB)
    imgG = rgb2gray(imgRGB);
    
    imageSize = size(imgRGB);
    numRows = imageSize(1);
    numCols = imageSize(2);

    wavelengthMin = 4/sqrt(2);
    wavelengthMax = hypot(numRows,numCols);
    n = floor(log2(wavelengthMax/wavelengthMin));
    wavelength = 2.^(0:(n-2)) * wavelengthMin;

    deltaTheta = 45;
    orientation = 0:deltaTheta:(180-deltaTheta);

    g = gabor(wavelength,orientation);

    gabormag = imgaborfilt(imgG,g);

    for i = 1:length(g)
        sigma = 0.5*g(i).Wavelength;
        K = 3;
        gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma); 
    end

    X = 1:numCols;
    Y = 1:numRows;
    [X,Y] = meshgrid(X,Y);
    featureSet = cat(3,gabormag,X);
    featureSet = cat(3,featureSet,Y);
    %Reshape data into a matrix X of the form expected by the kmeans function. Each pixel in the image grid is a separate datapoint, and each plane in the variable featureSet is a separate feature. In this example, there is a separate feature for each filter in the Gabor filter bank, plus two additional features from the spatial information that was added in the previous step. In total, there are 24 Gabor features and 2 spatial features for each pixel in the input image.

    %numPoints = numRows*numCols;
    X = reshape(featureSet,numRows*numCols,[]);
    %Normalize the features to be zero mean, unit variance.

    X = bsxfun(@minus, X, mean(X));
    X = bsxfun(@rdivide,X,std(X));
    
    coeff = pca(X);
    X = reshape(X*coeff(:,1),numRows,numCols);
    
    out_gabor = X;
    
end