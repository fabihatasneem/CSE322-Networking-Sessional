package Main;
import Threading.ServerThread;
import java.io.*;
import java.net.*;

public class Server {
    private static ServerSocket serverSocket;
    private static final int PORT = 5072;
    private static String root = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\HTTPFileServerOffline\\root";
    private static String log = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\HTTPFileServerOffline\\log";
    private static String upload = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\HTTPFileServerOffline\\root\\uploaded";

    public static void main(String[] args) throws IOException {
        for(File file: new File(log).listFiles()) {
            if (!file.isDirectory())
                file.delete();
        }
        try {
            serverSocket = new ServerSocket(PORT);
        }catch(IOException e){
            System.out.println("Server starts : "+e);
        }

        while(true) {
            new ServerThread(serverSocket.accept(), PORT, root, log, upload);
        }
    }
}
