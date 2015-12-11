function [names, features] = load_facial_features( face_dir, net)
names = {};
features = [];
if ~exist(face_dir, 'dir') 
    return; 
end

folders = dir(face_dir);
directoryNames = {folders([folders.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
idx = 1;
for i = 1:length(directoryNames)
        name = strrep(directoryNames{i}, '_', ' ');
        files = dir(fullfile(face_dir, directoryNames{i}, '/*.PNG'));
        imageNames = {files.name};
        imageNames = imageNames(~ismember(imageNames,{'.','..'}));
        avgFeatures = zeros(1, 4096); 
        for j = 1:length(files)
            img = imread(char(fullfile(face_dir, directoryNames(i), imageNames(j))));
            photoFeatures = extract_feature_vector(img, net);
            %photoFeatures = avgFeatures;
            avgFeatures = avgFeatures + photoFeatures;
        end
        avgFeatures = (1 / length(imageNames)) * avgFeatures;
        names{end+1} = name;
        features = [features; avgFeatures]; 
end


return
end
