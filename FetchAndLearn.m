close all;


%%Inizializzo un data store e creo la partizione di test
imdstr = imageDatastore('contrasted','IncludeSubfolders',true,'LabelSource','foldernames');

%Inizializzo densenet201
net = alexnet;

%%Ridimensiono le immagini in modo che siano compatibili con l'input di
%%densenet e faccio una dataset augmentation
inputSize = net.Layers(1).InputSize;
augimds = augmentedImageDatastore(inputSize(1:2),imdstr);


%%Scelgo che layer deve fermarsi la rete, mi fermo al 4o dense block prima
%%dell'ultimo layer convolutivo in modo da estrarre le features, usando una
%%rete pretrained ho una particolare efficenza a livello computazionale in
%%quanto estraggo le features scorrendo una sola volta i dati di input
%%richiedendo le attivazioni del layer con la funzione activations
layer = 24; 
features = activations(net,augimds,layer,'OutputAs','rows');
