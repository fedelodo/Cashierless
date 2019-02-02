
function [label,score] = ClassifyImage(imgPath,threshold,netFilePath,modelFilePath)
    % preprocessing
    out = Preprocessing(imgPath);
    
    % calcolo etichette componenti connesse per generare la boundingbox
    labels = logical(imbinarize(rgb2gray(out)));
    stats = regionprops(labels,'boundingbox'); 
    x = stats.BoundingBox;
    out = im2uint8(out);
    
    % carico la rete e il classificatore per estrarre le features
    load(netFilePath, 'netTransfer');
    load(modelFilePath, 'trainedModel');
    
    % faccio il calcolo delle features dell' immagine con la rete
   
    inputSize = netTransfer.Layers(1).InputSize;
    out = imresize(out,inputSize(1:2));    layer = 24; 
    featuresimg = activations(netTransfer,out,layer,'OutputAs','rows');
    
    % inizializzo il classificatore e lo utilizzo per classificare l'img
    Var1 = 0;
    features = featuresimg;
    T1 = table(Var1, features);
    [label, score] = trainedModel.predictFcn(T1);
   
    % soglio con una soglia preimpostata per decidere se l'oggetto è
    % classificabile
    if max(score) < threshold
      label = removecats(label);
      label = renamecats(label, 'unrecognized');
    end
    
    % genero il titolo nella forma "prodotto@percentuale di confidenza" e
    % disegno la boundingbox sull' immagine originale
    image = imread(imgPath);
    image = imresize(image, [300 300]);
    figure, imshow(image);
    title = strcat(char(label(1)),'@',int2str(max(score)*100),' %');
    hold on;
    rectangle('Position', x,  ...
    'EdgeColor','r', 'LineWidth', 3);
    text(x(1)+(x(3)/2), x(2)-15, title  ,'Color', 'red', 'FontSize', 20);
   
end