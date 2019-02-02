close all;

%%inizializzo un pool di risorse per il calcolo parallelo
%pool = parpool;

%%Inizializzo un data store e creo la partizione di test
imds = imageDatastore('contrasted','IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

%Inizializzo alexnet
net = alexnet;

%%Ridimensiono le immagini in modo che siano compatibili con l'input di
%%densenet e faccio una dataset augmentation
inputSize = net.Layers(1).InputSize;
imageAugmenter = imageDataAugmenter('RandRotation',[-20,20], ...
                                    'RandXTranslation',[-3 3], ...
                                    'RandYTranslation',[-3 3], ...
                                    'RandScale', [1 3], ...
                                    'RandXReflection', true, ...
                                    'RandYReflection', true, ...
                                    'RandXShear', [-3 3], ...
                                    'RandYShear', [-3 3]);
                                
augimds = augmentedImageDatastore(inputSize(1:2), imdsTrain,'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2), imdsValidation,'DataAugmentation',imageAugmenter);

%%Faccio il fitting della rete portando il numero di classi da riconoscere
%%da 1000 a 10
numClasses = numel(categories(imdsTrain.Labels));


%estraggo il grafo dei layer
if isa(net,'SeriesNetwork') 
  lgraph = layerGraph(net.Layers); 
else
  lgraph = layerGraph(net);
end 

%cerco i layer da modificare
 [learnableLayer,classLayer] = findLayersToReplace(lgraph);
 
 if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',15, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',15, ...
        'BiasLearnRateFactor',10);
 end
 
newClassLayer = classificationLayer('Name','new_classoutput');
 
lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

%mantieni le connessioni e freeza i pesi dei primi layer
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%Imposto le varie opzioni di training

options = trainingOptions('sgdm', ...
    'MaxEpochs',10, ...
    'MiniBatchSize',32, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

%Faccio il training della rete
netTransfer = trainNetwork(augimds,layers,options);

save('CNN.mat', netTransfer);