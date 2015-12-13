% This script preloads the network and features for the roster into 
% workspace. Note: This takes a bit, so don't run it unless absolutely 
% necessary.
% Also it has an optimization in that if {features, names} or {net}
% variables in the workspace already exist, it does not overwrite them 
% and skips the loading.
if exist('net') == 0
    fprintf('Loading neural network...');
    net = load('toolbox/models/vgg-face.mat');
    net.layers{37} = [];
    net.layers{36} = [];
    net.layers{35} = [];
    net.layers = net.layers(~cellfun('isempty',net.layers));
else
    fprintf('net already found in workspace. Skipping the load.');
end

if exist('names') == 1 && exist('features') == 1
    fprintf('{names, features} already found in workspace. Skipping the load.');
elseif exist('roster_names.mat', 'file') == 2 && ...
       exist('roster_features.mat', 'file') == 2
   
    fprintf('Loading {names, features} from file.')
    load('roster_features.mat', 'features');
    load('roster_names.mat', 'names');
   
else
    fprintf('Generating {names, features}...');
    [names, features] = loadFacialFeatures('roster', net);
end

