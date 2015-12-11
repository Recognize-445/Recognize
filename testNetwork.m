[names, features] = load_facial_features('Roster', net);

kyle_face = imread('kyle_face.jpg');
jack_face = imread('jack_face.jpg');
joyce_face = imread('joyce_face.jpg');

vec = extract_feature_vector(kyle_face, net);

names = guess_name(names, features, vec);

for i = 1:length(names)
    fprintf('%s, Score: %f\n', char(names{i}{1}), double(names{i}{2}));
end