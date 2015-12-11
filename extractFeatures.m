
function feat_vec = extractFeatures(im, network)
% Given an image (that had the face detected and aligned)
% and a neural network, this function will resize it to 
% 224x224x3, subtract the average image from it, and
% produce the 1x4096 feature vector.

addpath(genpath(fullfile('toolbox', 'matconvnet-1.0-beta16')));

im_ = single(im) ; % note: 255 range
im_ = imresize(im_, network.meta.normalization.imageSize(1:2)) ;
im_ = bsxfun(@minus,im_,network.meta.normalization.averageImage) ;
res = vl_simplenn(network, im_);

feat_vec = squeeze(gather(res(end).x))';

end