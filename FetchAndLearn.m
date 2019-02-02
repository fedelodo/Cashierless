function [Tab] = FetchAndLearn(netFilePath,layer)
%%Inizializzo un data store e creo la partizione di test
imdstr = imageDatastore('contrasted','IncludeSubfolders',true,'LabelSource','foldernames');

load(netFilePath, 'netTransfer');

%%Ridimensiono le immagini in modo che siano compatibili con l'input di
%%densenet e faccio una dataset augmentation
inputSize = netTransfer.Layers(1).InputSize;
augimds = augmentedImageDatastore(inputSize(1:2),imdstr);


%%Scelgo che layer deve fermarsi la rete, in modo da estrarre le features,
%%usando una rete pretrained ho una particolare efficenza a livello computazionale in
%%quanto estraggo le features scorrendo una sola volta i dati di input
%%richiedendo le attivazioni del layer con la funzione activations
features = activations(netTransfer,augimds,layer,'OutputAs','rows');

Tab = table(features, imdstr.Labels);
end