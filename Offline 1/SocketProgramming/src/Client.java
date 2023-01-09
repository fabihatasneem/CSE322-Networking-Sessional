public class Client {
    Client(String serverAddress, int serverPort){
        try {
            new WriteClient(serverAddress, serverPort);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        String serverAddress = "127.0.0.1";
        int serverPort = 5072;
        new Client(serverAddress, serverPort);
    }
}
