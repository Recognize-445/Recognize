function [ sData ] = standardize( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    mData = mean(data, 4);
    stdData = std(data, 0, 4);
    sub = bsxfun(@minus, data, mData);
    sData = bsxfun(@rdivide, sub, stdData);

end

