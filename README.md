# Recognize
Recognize is an application which can be used for facial recognition. It includes a server which can listen for images and return a name prediction. This was done as the final project for EECS 445 for the Fall 2015 semester at the University of Michigan.

# Installation
This application requires you to install the following software packages:
<li>[Matlab](http://www.mathworks.com/products/matlab/?refresh=true)</li>
<li>[MatConvNet](http://www.vlfeat.org/matconvnet/)</li>
<li>[Frontalize](http://www.openu.ac.il/home/hassner/projects/frontalize/)</li>


# Usage
The code contained in this repository can be used for both training a neural network to learn features of faces and as a server which predicts names based on the previously trained model. If you do not wish to train your own network, you can download and use the pre-trained [VGG-Face model](http://www.vlfeat.org/matconvnet/pretrained/#face-recognition). At this point, you simply need to run <i>recognizeServer.m</i> in order to start the server.

alignCrop - this code is used for frontalization, alignment, and normalization of the face for our neural network (not VGG-Face).

extractFeatures - given the VGG-Face neural network and the image, this function will extract the 1x4096 feature vector.

loadFacialFeatures - applies detectCrop to each roster image (roster at face_dir) and uses the neural net given in order to extract features from each.

loadNetwork - loading function that loads up and properly modifies the VGG-Face neural network (assumes it is at toolbox/models/vgg-face.mat) (doesn't load it if already in the workspace), generates names and feature vectors from the roster folder (or just loads them in if roster\_features.mat, roster\_names.mat exists in current working directory).

neuralNetwork - matconvnet description of our original (large) neural network.

neuralNetworkSmall - matconvnet description of the network we decided to use for training.

normalize - function to normalize an image.

predictName - given a normalized image of a face, this function is used to predict its owner's name.

recognizeServer - loads up a network and starts to listen for requests from an application on port 9090 and the public server IP. Replies with the prediction when done.

roster\_features, roster\_names - precomputed features and names for the EECS445 roster

testNetwork, trainNetwork - functions to test and train our neural network

# Client Application
A Google Glass application which makes use of this server can be found [here](https://github.com/kbalouse/RecognizeClient).

#Contributors
Kyle Balousek, Oleks Tyberkevych, Joyce Zhang, Haizhou Zhao
