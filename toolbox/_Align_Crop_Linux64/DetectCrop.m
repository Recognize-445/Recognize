function outputImage = DetectCrop(imageName, model, Model3D, eyemask, REFTFORM, REFSZ)
% Load query image
I_Q = imread(imageName);

fidu_XY = FacialFeatureDetection(I_Q, model);
if isempty(fidu_XY)
    %error('Failed to detect facial features / find face in image.');
    fprintf('Failed to detect facial features on the image:');
    fprintf(imageName);
    fprintf(' Skipping image...\n');
    outputImage = [];
    return;
end

% Estimate projection matrix C_Q
%[C_Q, ~,~,~] = estimateCamera(Model3D, fidu_XY);

% Render frontal view
%[frontal_sym, frontal_raw] = Frontalize(C_Q, I_Q, Model3D.refU, eyemask);


% Apply similarity transform to LFW-a coordinate system, for compatability
% with existing methods and results
%frontal_sym = imtransform(frontal_sym,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);
%frontal_raw = imtransform(frontal_raw,REFTFORM,'XData',[1 REFSZ(2)], 'YData',[1 REFSZ(1)]);

%fidu_XY = FacialFeatureDetection(frontal_sym, model);
%if isempty(fidu_XY)
    %error('Failed to detect facial features / find face in image.');
%    fprintf('Failed to detect facial features on the image:');
%    fprintf(imageName);
%    fprintf(' Skipping image...\n');
%    outputImage = [];
%    return;
%end

%outputImage = imcrop(frontal_sym, [min(fidu_XY(:,1)) min(fidu_XY(:,2)) max(fidu_XY(:,1))-min(fidu_XY(:,1)) max(fidu_XY(:,2))-min(fidu_XY(:,2))]);
minx = min(fidu_XY(:, 1));
miny = min(fidu_XY(:, 2));
width = max(fidu_XY(:,1))-min(fidu_XY(:,1));
height = max(fidu_XY(:,2))-min(fidu_XY(:,2));

width_offset = 0.2 * width;
height_offset = 0.7 * height;

minx = max(minx - width_offset, 1);
miny = max(miny - height_offset, 1);
width = 2 * width_offset + width;
height = 1.5 * height_offset + height;

outputImage = imcrop(I_Q, [minx miny width height]);


% Display results
%figure; imshow(I_Q); title('Query photo');
%figure; imshow(I_Q); hold on; plot(fidu_XY(:,1),fidu_XY(:,2),'.'); hold off; title('Query photo with detections overlaid');
%figure; imshow(frontal_raw); title('Frontalilzed no symmetry');
%figure; imshow(frontal_sym); title('Frontalilzed with soft symmetry');
%figure; imshow(imcrop(frontal_sym, [min(fidu_XY(:,1)) min(fidu_XY(:,2)) max(fidu_XY(:,1))-min(fidu_XY(:,1)) max(fidu_XY(:,2))-min(fidu_XY(:,2))]));
end