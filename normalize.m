function [ nData ] = normalize( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %nSample = size(data, 4);
    %nData = ones(size(data));
    %dim = size(data, 3);
    %for i = 1:nSample
    %    for j = 1:dim
    %        im_channel = data(:,:,j,i);
    %        im_size = size(im_channel,1);
    %        mData = mean2(im_channel) * ones(im_size, im_size);
    %        sub = im_channel - mData;
    %        norm = norm(reshape(im_channel, [48*48 1]));
    %        sub = sub ./ norm;
    %        nData(:,:,j,i) = sub;
    %    end
    %end
    
    mData = mean(mean(data, 1), 2);
    sub = bsxfun(@minus, data, mData);
    factor = sqrt(sum(sum(sub .^2, 1),2));
    nData = bsxfun(@rdivide, sub, factor);
end

