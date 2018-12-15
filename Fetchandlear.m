clear all;
clearvars;
imds = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');
[train,test] = splitEachLabel(imds,0.7,'randomized');
net = alexnet;
inputSize = net.Layers(1).InputSize;
augimdsTrain = augmentedImageDatastore(inputSize(1:2),train);
augimdsTest = augmentedImageDatastore(inputSize(1:2),test);
layer = 'fc7';
featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
knn = fitcknn(featuresTrain, train.Labels);
predicted_test_knn = predict(knn, featuresTest);
performance_test_knn = confmat(test.Labels, predicted_test_knn);
figure
for i = 1:7
    subplot(2,2,i)
    I = readimage(test,i);
    label = predicted_test_knn(i);
    imshow(I)
    title(char(label))
end
