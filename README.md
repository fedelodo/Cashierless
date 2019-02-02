# Cashierless
The objective is to describe supermarket items from a camera view and make a Checkout (School Project).

## How to generate models

1. Put your dataset into the folder images with the structure images/class/...
2. Run CreateContrastImageSet to apply preprocessing to all the images into 
    the dataset
3. Run ClassifierTest to retrain your chosen network, it generates a file 
    called CNN.mat
4. Run the function FetchAndLearn, the arguments are:
    * the filepath of the network model (optional, defaults to CNN.mat)
    * the layer where you want to extract the features (24th layer with alexnet suggested)
    the function returns a table with labels from the imgs and features
5. Run Classification Learner App, use the table frome the previous step as
    input, choose the most accurate classifier model and export it into a .mat
    file. Save the model as 'trainedModel'.

## How to classify an image

Run ClassifyImage function, the arguments are:
- Path to the image that you want to classify
- A threshold to eliminate false positives 
- Path to the classifier .mat
- Path to the network .mat (optional, defaults to CNN.mat)

The function displays the image and outputs the predicted label and score.

