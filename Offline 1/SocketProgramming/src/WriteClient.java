import java.io.*;
import java.util.Scanner;

public class WriteClient implements Runnable{
    private Thread thr;
    private NetworkUtil networkUtil;
    private Scanner scanner;
    private String serverAddress;
    private int serverPort;

    public WriteClient(String serverAddress, int serverPort) {
        this.serverPort = serverPort;
        this.serverAddress = serverAddress;
        this.thr = new Thread(this);
        this.scanner = new Scanner(System.in);
        this.thr.start();
    }

    @Override
    public void run() {
        while (true) {
            this.networkUtil = new NetworkUtil(this.serverAddress, this.serverPort);
            File file = new File(scanner.nextLine());
            networkUtil.printWrite("UPLOAD " + file.getName() + "\r\n");
            if (file.exists()) {
                networkUtil.printWrite("fileOkay\r\n");
                String extension = file.getName().split("\\.")[1];
                if (extension.equals("txt") || extension.equals("jpg") || extension.equals("png") || extension.equals("mp4")) {
                    networkUtil.upload_client(file);
                } else {
                    System.out.println("File format not supported");
                }
            } else {
                networkUtil.printWrite("fileNotOkay\r\n");
                System.out.println("File not found.");
            }
        }
    }
}
