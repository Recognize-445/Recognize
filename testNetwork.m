% Uncomment to load the network
% net = load('toolbox/models/vgg-face.mat');
% net.layers{37} = [];
% net.layers{36} = [];
% net.layers{35} = [];
% net.layers = net.layers(~cellfun('isempty',net.layers))  
% 
% [names, features] = loadFacialFeatures('roster', net);

addpath(genpath(fullfile('toolbox', 'frontalize.0.1.2')));
addpath(genpath(fullfile('toolbox', 'frontalize.0.1.2', 'calib')));
addpath(genpath(fullfile('toolbox', 'frontalize.0.1.2', 'ZhuRamanan')));
load('toolbox/frontalize.0.1.2/ZhuRamanan/face_p146_small.mat','model');
load model3DZhuRamanan Model3D % reference 3D points corresponding to Zhu & Ramanan detections
load eyemask eyemask % mask to exclude eyes from symmetry
load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates

test_face = imread('testimage/kyle2.jpg');
proc_face = alignCrop('testimage/kyle2.jpg', model, Model3D, eyemask, REFTFORM, REFSZ);
imshow(proc_face);

test_features = extractFeatures(test_face, net);

predictions = predictName(names, features, test_features);

for i = 1:20
    fprintf('%s, Score: %f\n', char(predictions{i}{1}), double(predictions{i}{2}));
end