if ~exist('result', 'dir'), mkdir('result'); end
if ~exist('tmp', 'dir'), mkdir('tmp'); end

nTrain = 10; %need to replace nTrain with number of train samples
trainData = ones(48, 48, 3, nTrain);
trainLabels = ones(1, nTrain);

files = dir('data');
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
currentIdx = 1;
for i = 1:length(directoryNames)
        files = dir(strcat('data/', directoryNames{i}, '/*.jpg'));
        for j = 1:length(files)
            im = imread(char(fullfile('data', directoryNames(i), files(j).name)));
            im_ = imresize(im, [48, 48]);
            %imshow(im_);
            trainData(:,:,:,currentIdx) = im_;
            trainLabels(:, currentIdx) = i;
            currentIdx = currentIdx + 1;
            
        end
end

save(fullfile('tmp', 'train.mat'), 'trainData', 'trainLabels');

normalizedTrainData = normalize(double(trainData));
save(fullfile('tmp', 'normalizedTrain.mat'), 'normalizedTrainData', 'trainLabels');

normalizedStandardizedTrainData = standardize(normalizedTrainData);
save(fullfile('result', 'normalizedStandardizedTrainData.mat'), ...
    'normalizedStandardizedTrainData', 'trainLabels');

clear trainData normalizedTrainData;

initW = 1e-2;
initB = 1e-1;

addpath(genpath(fullfile('toolbox0', 'matconvnet-1.0-beta16')));
addpath(genpath(fullfile('toolbox0', 'cnn')));

run neural_network_sm.m;

%opts need to be changed
opts.continue = true;
opts.gpus = [];
opts.expDir = fullfile('tmp', 'trained_facial_identification_nn');
if exist(opts.expDir, 'dir') ~= 7, mkdir(opts.expDir); end

opts.learningRate = 1e-2;
opts.batchSize = 4;
opts.numEpochs = 30;

[trainIdx, valIdx] = crossvalind('HoldOut', nTrain, 0.5);
trained_facial_identification_nn = cnnTrain(normalizedStandardizedTrainData(:,:,:,trainIdx),...
    trainLabels(:, trainIdx), ...
    normalizedStandardizedTrainData(:,:,:, valIdx), trainLabels(:, valIdx),...
    face_identification_nn, opts) ;
copyfile(fullfile(opts.expDir, 'net-train.pdf'), ...
    fullfile('result', 'trained_facial_identification_nn.pdf'));

save(fullfile('result', 'trained_facial_identification_nn.mat'),...
    'trained_facial_identification_nn');

%-------------------------------------------------------------------
