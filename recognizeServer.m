% Apparently you can write Java code in MATLAB
import java.io.PrintWriter;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.BufferedInputStream;

addpath(fullfile('toolbox', '_Align_Crop_Linux64', 'calib'));
addpath(fullfile('toolbox', '_Align_Crop_Linux64', 'ZhuRamanan'));
load('ZhuRamanan/face_p146_small.mat','model');
load model3DZhuRamanan Model3D % reference 3D points corresponding to Zhu & Ramanan detections
% load some data
load eyemask eyemask % mask to exclude eyes from symmetry
load DataAlign2LFWa REFSZ REFTFORM % similarity transf. from rendered view to LFW-a coordinates

% After this run we get the net, names, and (roster) features variables.
run loadNetwork.m

% Port number to listen for connections on
PORT_NUMBER = 9090;

% Time before client is considered to have timed out (milliseconds)
CLIENT_TIMEOUT = 20000;

% Time before server reattempts connection.
SERVER_TIMEOUT = 5000;

% Start listening on port PORT
server = ServerSocket(PORT_NUMBER);

server_public_ip_addr = urlread('http://ipinfo.io/ip');
fprintf('Server public IP addr: %s\n', char(server_public_ip_addr));
fprintf('Listening on port: %d\n', PORT_NUMBER);

server.setSoTimeout(SERVER_TIMEOUT);

while true
    try
        % Server waits for client to connect
        try
            client = server.accept();
        catch exception
            continue
        end
        client.setSoTimeout(CLIENT_TIMEOUT);
        fprintf('Client has connected.\n');

        % Set up client text and byte readers
        client_text = BufferedReader(InputStreamReader(client.getInputStream()));
        client_bytes = BufferedInputStream(client.getInputStream());

        % Get the number of bytes and allocate buffer for photo
        bytes = str2num(client_text.readLine());
        buf = uint8(java.util.Arrays.copyOf(uint8(zeros(bytes,1)),bytes));
        fprintf('Reading %d bytes from the client.\n', bytes);

        % Read photo data from Glass
        % This could probably be written more efficiently,
        % but it works for our purposes
        total = 0;        
        while total < bytes
            byte = uint8(client_bytes.read());
            %char(byte)
            buf(total+1) = byte;
            total = total + 1;
        end

        % Save photo to this directory as GlassPhoto.jpg
        image_file = FileOutputStream('GlassPhoto.jpg');
        image_file.write(buf, 0, total);
        image_file.close();
        fprintf('Image saved to disk.\n');

        % At this point, we have the image saved and should be able to
        % use our model to make a prediction on the person's name
        
        proc_face = DetectCrop('GlassPhoto.jpg', model, Model3D, eyemask, REFTFORM, REFSZ);
        fprintf('Recognizing...\n');
        if isempty(proc_face)
            server_response = PrintWriter(client.getOutputStream(), true);
            server_response.println('No face detected. Try again.');
            fprintf('No face detected.\n');
            fprintf('Connection to client closed safely.\n');
            client.close();
            continue;
        end
        imshow(proc_face);
        test_features = extractFeatures(proc_face, net);
        
        predictions = predictName(names, features, test_features);

        name_prediction = predictions{1}{1};
        fprintf('Predicted as %s\n with score %f\n', char(name_prediction), double(predictions{1}{2}));
        
        
        % Respond to the client with the person's name
        server_response = PrintWriter(client.getOutputStream(), true);
        server_response.println(name_prediction);
    


        % Close the connection to the client
        client.close();
        fprintf('Connection to client closed safely.\n');
    catch exception
        if(isa(exception, 'matlab.exception.JavaException'))
            fprintf('ERROR: Connection to client lost.\n');
            client.close();
        else
        %else
        %    error(exception.identifier, 'Connection Error: %s', exception.message)
        %    fprintf('Connection Error.\n');
        %    client.close();
        %end
            client.close();
            server.close();
            rethrow(exception);
        end
    end
end

% Close server socket
server.close();