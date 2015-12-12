function [ sub ] = normalize( data )

    
    mData = mean(mean(mean(data, 1), 2), 4);
    sub = bsxfun(@minus, data, mData);
    %factor = sqrt(sum(sum(sub .^2, 1),2));
    %nData = bsxfun(@rdivide, sub, factor);
end

