function net = cnnTrain(trainData, trainLabels, valData, valLabels, initNet, opts)

nTrain = size(trainLabels, 2);
nVal = size(valLabels, 2);

imdb.imHeight = size(trainData, 2);
imdb.imWidth = size(trainData, 1);
                                                               
%disp(imdb.imHeight);
imdb.images.data = single(cat(4, trainData, valData));
imdb.images.labels = single(cat(2, trainLabels, valLabels));
imdb.images.set = cat(2, ones(1, nTrain), 3*ones(1, nVal));
[net, ~] = cnn_train(initNet, imdb, @getBatch, opts, 'val', find(imdb.images.set == 3));
net = vl_simplenn_move(net, 'cpu');

end

function [im, labels] = getBatch(imdb, batch)
im = imdb.images.data(:,:,:,batch);
labels = imdb.images.labels(1,batch);
end
