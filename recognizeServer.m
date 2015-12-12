% Apparently you can write Java code in MATLAB
import java.io.PrintWriter;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.BufferedInputStream;

% Port number to listen for connections on
PORT_NUMBER = 9090;

% Time before client is considered to have timed out (milliseconds)
CLIENT_TIMEOUT = 1000;

% Start listening on port PORT
server = ServerSocket(PORT_NUMBER);

while true
    try
        % Server waits for client to connect
        client = server.accept();
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
        names = {};
        names{end+1} = 'Kyle Balousek';
        names{end+1} = 'Oleks Tyberkevych';
        names{end+1} = 'Joyce Zhang';
        names{end+1} = 'Jack Zhao';
        name_prediction = names{ceil(rand*4)};

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
            %error(ME.identifier, 'Connection Error: %s', ME.message)
            fprintf('Connection Error.\n');
            client.close();
        end
    end
end

% Close server socket
server.close();