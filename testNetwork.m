% Uncomment to load the network
%net = load('toolbox/models/vgg-face.mat');
%net.layers{37} = [];
%net.layers{36} = [];
%net.layers{35} = [];
%net.layers = net.layers(~cellfun('isempty',net.layers));
 
%[names, features] = loadFacialFeatures('roster', net);

%test_face = imread('testimage/oleks.jpg');
proc_face = DetectCrop('testimage/jack.jpg', model, Model3D, eyemask, REFTFORM, REFSZ);
imshow(proc_face);

test_features = extractFeatures(proc_face, net);

predictions = predictName(names, features, test_features);

for i = 1:20
    fprintf('%s, Score: %f\n', char(predictions{i}{1}), double(predictions{i}{2}));
end