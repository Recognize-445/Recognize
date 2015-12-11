function [ results ] = guess_name( names, features, unknown )

predictions = [];
unknown = unknown * (1 / norm(unknown));

name = '';
min_similarity = flintmax;
for i = 1:length(names)
    new_feature = features(i, :) * (1 / norm(features(i, :)));
    similarity = norm(new_feature - unknown);
    predictions = [predictions; i, similarity];
end

predictions = sortrows(predictions, 2);

results = {};
for i = 1:length(names)
    results{end+1} = {names(predictions(i,1)), predictions(i,2)};
end

    
return;
end

