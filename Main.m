clearvars;
close all;

%{
TEST MAIN
%}

imgPath = 'birra1.jpg';
netFile = 'alex72.mat';
modelFile = 'cubicknn767.mat';
T = 0.50;

[label, score] = ClassifyImage(imgPath,T,netFile,modelFile);


%{
TEST PREPROCESSING 

imgPath = 'images/biscuits/w4vsw.png';

out = Preprocessing(imgPath);

imshow(out);

%}
