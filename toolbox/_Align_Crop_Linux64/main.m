addpath(fullfile('calib'));
addpath(fullfile('ZhuRamanan'));
load('ZhuRamanan/face_p146_small.mat','model');
load model3DZhuRamanan Model3D % reference 3D points corresponding to Zhu & Ramanan detections
% load some data
load eyemask eyemask % mask to exclude eyes from symmetry
load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates

folders = dir('..');
DatabaseDir = '../';

for i = 1:length(folders)
    ImageDir = strcat(DatabaseDir, folders(i).name, '/');
    OutputDir = strcat(DatabaseDir, folders(i).name, '_Preprocessed/');
    imageFiles = dir(strcat(ImageDir, '*.jpg'));
    if ~isempty(imageFiles)
        mkdir(OutputDir);
    end
    for j = 1:length(imageFiles)
        SrcImage = strcat(ImageDir, imageFiles(j).name);
        destImage = strcat(OutputDir, imageFiles(j).name);
        processedImage = AlignCrop(SrcImage, model, Model3D, eyemask, REFTFORM, REFSZ);
        if ~isempty(processedImage)
            imwrite(processedImage, destImage);
        end
    end
end