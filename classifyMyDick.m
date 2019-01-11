
img = '/home/federico/git/Cashierless/images/beer/WhatsApp Image 2018-12-16 at 21.56.08.jpeg';
T = 0.50;

    out = provaPreprocessing2(img);
    
    labels = logical(imbinarize(rgb2gray(out)));

    stats = regionprops(labels,'boundingbox');
    
    x = stats.BoundingBox;
    out = im2uint8(out);
    load('untitled.mat');
    net = alexnet;
    inputSize = net.Layers(1).InputSize;
    augimg = augmentedImageDatastore(inputSize(1:2),out);
    layer = 24; 
    featuresimg = activations(net,augimg,layer,'OutputAs','rows');
   Var1 = 0;
   Var2 = featuresimg;
   T1 = table(Var1, Var2);
   [label, score] = trainedModel1.predictFcn(T1);
    if max(score) < T
      label = removecats(label);
      label = renamecats(label, 'NC');
    end
    figure, imshow(img);
    hold on;
    rectangle('Position', x,  ...
  'EdgeColor','r', 'LineWidth', 3);
   text(x(1)+(x(3)/2), x(2)-20, char(label(1)),'Color', 'red', 'FontSize', 20);
