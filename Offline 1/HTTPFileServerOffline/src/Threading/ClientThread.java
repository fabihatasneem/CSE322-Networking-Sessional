package Threading;

import java.io.*;
import java.net.Socket;

public class ClientThread implements Runnable {
    private Socket socket;
    private Thread thread;
    private File file;
    public ClientThread(String input){
        this.file = new File(input);
        Thread thread = new Thread(this);
        thread.start();
    }
    @Override
    public void run() {
        PrintWriter pr = null;
        try {
            socket = new Socket("localhost", 5072);
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            pr = new PrintWriter(socket.getOutputStream());
            pr.write("UPLOAD " + file.getName() + "\r\n");
            pr.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }

        if(file.exists()){
            pr.write("fileOkay\r\n");
            pr.flush();
            try {
                OutputStream os = socket.getOutputStream();
                BufferedInputStream is = new BufferedInputStream(new FileInputStream(file));
                byte[] data = new byte[1024];
                int byteContent;
                while ((byteContent = is.read(data, 0, 1024)) != -1) {
                    os.write(data, 0, byteContent);
                    os.flush();
                }
                is.close();
                os.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println("File sent to server.");
        }
        else{
            pr.write("fileNotOkay\r\n");
            System.out.println("File not found ");
            pr.flush();
        }

        try {
            pr.close();
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
