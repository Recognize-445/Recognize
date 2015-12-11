function net = cnnTrain(trainData, trainLabels, valData, valLabels, initNet, opts)

%dim = 3;
nTrain = size(trainLabels, 1);
nVal = size(valLabels, 1);

%imdb.imHeight = sqrt(size(trainData, 2) / dim);
%imdb.imWidth = imdb.imHeight;
imdb.imHeight = size(trainData, 2);
imdb.imWidth = size(trainData, 1);
                                                               
disp(imdb.imHeight);
imdb.images.data = single(cat(4, trainData, valData));
imdb.images.labels = single(cat(1, trainLabels, valLabels)');
imdb.images.set = cat(2, ones(1, nTrain), 3*ones(1, nVal));

size(imdb.images.data)
size(imdb.images.labels)
size(imdb.images.set)

[net, ~] = cnn_train(initNet, imdb, @getBatch, opts, 'val', find(imdb.images.set == 3));
net = vl_simplenn_move(net, 'cpu');

end

function [im, labels] = getBatch(imdb, batch)
im = imdb.images.data(:,:,:,batch);
labels = imdb.images.labels(1,batch);
end
