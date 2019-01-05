close all;


%%Inizializzo un data store e creo la partizione di test
imdstr = imageDatastore('contrasted','IncludeSubfolders',true,'LabelSource','foldernames');
[train, test] = splitEachLabel(imdstr,0.7,'randomized');


%Inizializzo densenet201

%%Ridimensiono le immagini in modo che siano compatibili con l'input di
%%densenet e faccio una dataset augmentation
inputSize = netTransfer.Layers(1).InputSize;
augimdsTrain = augmentedImageDatastore(inputSize(1:2),train);
augimdsTest = augmentedImageDatastore(inputSize(1:2),test);

%%Scelgo che layer deve fermarsi la rete, mi fermo al 4o dense block prima
%%dell'ultimo layer convolutivo in modo da estrarre le features, usando una
%%rete pretrained ho una particolare efficenza a livello computazionale in
%%quanto estraggo le features scorrendo una sola volta i dati di input
%%richiedendo le attivazioni del layer con la funzione activations
layer = 'fc'; 
featuresTrain = activations(netTransfer,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(netTransfer,augimdsTest,layer,'OutputAs','rows');

%Creazione classificatori knn, ctree e utilizzo l' ensemble learning
knn = fitcknn(featuresTrain, train.Labels);
ctree = fitctree(featuresTrain, train.Labels);
ens = fitcensemble(featuresTrain,train.Labels,'Method','LPBoost','NumLearningCycles',50,'Learners','tree');

%Classificazione knn
predicted_test_knn = predict(knn, featuresTest);
performance_test_knn = confmat(test.Labels, predicted_test_knn);

%Classificazione ctree
predicted_test_ctree = predict(ctree, featuresTest);
performance_test_ctree = confmat(test.Labels, predicted_test_ctree);

%Classificazione con ensemble learning 
predicted_test_ens = predict(ens, featuresTest);
performance_test_ens = confmat(test.Labels, predicted_test_ens);

%visualizza risultati predictions

figure('NumberTitle', 'off', 'Name', 'knn');
for i = 1:30
    subplot(6,5,i)
    I = readimage(test,i);
    label = predicted_test_knn(i);
    imshow(I)
    title(char(label))
end

figure('NumberTitle', 'off', 'Name', 'ctree');
for i = 1:30
    subplot(6,5,i)
    I = readimage(test,i);
    label = predicted_test_ctree(i);
    imshow(I)
    title(char(label))
end

figure('NumberTitle', 'off', 'Name', 'ensemble');
for i = 1:30
    subplot(6,5,i)
    I = readimage(test,i);
    label = predicted_test_ens(i);
    imshow(I)
    title(char(label))
end