clear all;
clearvars;
imds = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');
[train,test] = splitEachLabel(imds,0.7,'randomized');
net = densenet201;
inputSize = net.Layers(1).InputSize;
augimdsTrain = augmentedImageDatastore(inputSize(1:2),train);
augimdsTest = augmentedImageDatastore(inputSize(1:2),test);
layer = 'bn'; %% Scegli a che layer deve fermarsi la rete, mi fermo al 4o dense block
featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
knn = fitcknn(featuresTrain, train.Labels);
ctree = fitctree(featuresTrain, train.Labels);
ens = fitcensemble(featuresTrain,train.Labels,'Method','LPBoost','NumLearningCycles',50,'Learners','tree');
predicted_test_knn = predict(knn, featuresTest);
performance_test_knn = confmat(test.Labels, predicted_test_knn);
predicted_test_ctree = predict(ctree, featuresTest);
performance_test_ctree = confmat(test.Labels, predicted_test_ctree);
predicted_test_ens = predict(ens, featuresTest);
performance_test_ens = confmat(test.Labels, predicted_test_ens);
figure('NumberTitle', 'off', 'Name', 'knn');
for i = 1:4
    subplot(2,2,i)
    I = readimage(test,i);
    label = predicted_test_knn(i);
    imshow(I)
    title(char(label))
end
figure('NumberTitle', 'off', 'Name', 'ctree');
for i = 1:4
    subplot(2,2,i)
    I = readimage(test,i);
    label = predicted_test_ctree(i);
    imshow(I)
    title(char(label))
end
figure('NumberTitle', 'off', 'Name', 'ensemble');
for i = 1:4
    subplot(2,2,i)
    I = readimage(test,i);
    label = predicted_test_ens(i);
    imshow(I)
    title(char(label))
end