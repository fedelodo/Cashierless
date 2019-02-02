clearvars;
close all;

%{
TEST MAIN
%}

imgPath = 'path/to/image';
netFile = 'path/to/cnn';
modelFile = 'path/to/classifier';
T = 0.50;

[label, score] = ClassifyImage(imgPath,T,netFile,modelFile);


%{
TEST PREPROCESSING 

imgPath = 'images/biscuits/w4vsw.png';

out = Preprocessing(imgPath);

imshow(out);

%}
