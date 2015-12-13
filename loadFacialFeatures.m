function [names, features] = loadFacialFeatures( face_dir, net)

addpath(fullfile('toolbox', '_Align_Crop_Linux64', 'calib'));
addpath(fullfile('toolbox', '_Align_Crop_Linux64', 'ZhuRamanan'));
load('ZhuRamanan/face_p146_small.mat','model');
load model3DZhuRamanan Model3D % reference 3D points corresponding to Zhu & Ramanan detections
% load some data
load eyemask eyemask % mask to exclude eyes from symmetry
load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates


names = {};
features = [];
if ~exist(face_dir, 'dir') 
    return; 
end

folders = dir(face_dir);
directoryNames = {folders([folders.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
for i = 1:length(directoryNames)
        bad_img = false;
        name = strrep(directoryNames{i}, '_', ' ');
        name
        files = dir(fullfile(face_dir, directoryNames{i}, '/*.PNG'));
        files = [files; dir(fullfile(face_dir, directoryNames{i}, '/*.png'))];
        imageNames = {files.name};
        imageNames = imageNames(~ismember(imageNames,{'.','..'}));
        avgFeatures = zeros(1, 4096); 
        for j = 1:length(files)
            target_img_path = char(fullfile(face_dir, directoryNames(i), imageNames(j)));
            processedImage = DetectCrop(target_img_path, model, Model3D, eyemask, REFTFORM, REFSZ);
            if ~isempty(processedImage)
                imshow(processedImage);
            	photoFeatures = extractFeatures(processedImage, net);
                avgFeatures = avgFeatures + photoFeatures;
            else
                bad_img = true;
                break;
            end
        end
        if bad_img == false
            avgFeatures = (1 / length(imageNames)) * avgFeatures;
            names{end+1} = name;
            features = [features; avgFeatures]; 
        end
end

return
end

