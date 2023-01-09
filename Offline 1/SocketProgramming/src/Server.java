import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    private ServerSocket serverSocket;
    private static final int PORT = 5072;
    private static String root = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\SocketProgramming\\root";
    private static String log = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\SocketProgramming\\log";
    private static String upload = "E:\\3-2\\CSE322 - 1.5 - Networking Sessional\\CSE322-Networking-Sessional\\Offline 1\\SocketProgramming\\root\\uploaded";

    Server(){
        try{
            serverSocket = new ServerSocket(5072);
            while(true) {
                Socket clientSocket = serverSocket.accept();
                serve(clientSocket);
            }
        }catch (IOException e){
            System.out.println("Server starts with exception: " + e);
        }
    }
    public void serve(Socket clientSocket){
        NetworkUtil networkUtil = new NetworkUtil(clientSocket);
        new ReadServer(networkUtil, PORT, root, log, upload);
    }
    public static void main(String[] args) {
        new Server();
    }
}
