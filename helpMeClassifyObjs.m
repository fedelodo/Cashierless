close all;

img = '/home/dige/Scrivania/birra4.jpeg';
netFile = '/home/dige/Scrivania/fittedAlexNet70%acc0.7%loss.mat';
modelFile = '/home/dige/Scrivania/mediumTree81%.mat';
T = 0.50;

out = Preprocessing(img);
imshow(out);

labels = logical(imbinarize(rgb2gray(out)));

stats = regionprops(labels,'boundingbox');

x = stats.BoundingBox;
out = im2uint8(out);
load(netFile);
load(modelFile);

inputSize = netTransfer.Layers(1).InputSize;
augimg = augmentedImageDatastore(inputSize(1:2),out);
layer = 24; 
featuresimg = activations(netTransfer,augimg,layer,'OutputAs','rows');

Var1 = 0;
Var2 = featuresimg;

T1 = table(Var1, Var2);
[label, score] = trainedModel2.predictFcn(T1);
if max(score) < T
  label = removecats(label);
  label = renamecats(label, 'NC');
end

figure, imshow(img);
hold on;
rectangle('Position', x,  ...
'EdgeColor','r', 'LineWidth', 3);
text(x(1)+(x(3)/2), x(2)-20, char(label(1)),'Color', 'red', 'FontSize', 20);
