package Main;

import Threading.ClientThread;
import java.util.Scanner;

public class Client {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while(true){
            new ClientThread(scanner.nextLine());
        }
    }
}
