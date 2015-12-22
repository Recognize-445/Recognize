# Recognize
Recognize is an application which can be used for facial recognition. It includes a server which can listen for images and return a name prediction. This was done as the final project for EECS 445 for the Fall 2015 semester at the University of Michigan.

# Installation
This application requires you to install the following software packages:
<li>[Matlab](http://www.mathworks.com/products/matlab/?refresh=true)</li>
<li>[MatConvNet](http://www.vlfeat.org/matconvnet/)</li>
<li>[Frontalize](http://www.openu.ac.il/home/hassner/projects/frontalize/)</li>


# Usage
The code contained in this repository can be used for both training a neural network to learn features of faces and as a server which predicts names based on the previously trained model. If you do not wish to train your own network, you can download and use the pre-trained [VGG-Face model](http://www.vlfeat.org/matconvnet/pretrained/#face-recognition). At this point, you simply need to run <i>recognizeServer.m</i> in order to start the server.

# Client Application
A Google Glass application which makes use of this server can be found [here](https://github.com/kbalouse/RecognizeClient).

#Contributors
Kyle Balousek, Oleks Tyberkevych, Joyce Zhang, Haizhou Zhao
