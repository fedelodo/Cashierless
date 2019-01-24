clearvars;
close all;

imgPath = '/home/dige/Scrivania/immagini nuove dataset/birra2.jpg';
netFile = '/home/dige/Scrivania/fittedAlexNet70%acc0.7%loss.mat';
modelFile = '/home/dige/Scrivania/mediumTree81%.mat';
T = 0.50;

[label, score] = classifyMyDick(imgPath,T,netFile,modelFile);

