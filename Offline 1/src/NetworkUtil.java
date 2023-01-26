import java.io.*;
import java.net.Socket;

public class NetworkUtil {
    private Socket socket;
    private PrintWriter pw;
    private BufferedReader br;
    private DataInputStream dis;
    private DataOutputStream dos;

    public NetworkUtil(String s, int port) {                //client
        try {
            this.socket = new Socket(s, port);
            pw = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
            br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            dos = new DataOutputStream(socket.getOutputStream());
        } catch (Exception e) {
            System.out.println("In NetworkUtil : " + e);
        }
    }

    public NetworkUtil(Socket s) {                      //server
        try {
            this.socket = s;
            pw = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
            br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            dis = new DataInputStream(socket.getInputStream());
        } catch (Exception e) {
            System.out.println("In NetworkUtil : " + e);
        }
    }

    public String read() {
        try {
            return br.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void printWrite(String str){
        pw.write(str);
        pw.flush();
    }

    public void download(File file, byte[] data){
        try {
            BufferedInputStream is = new BufferedInputStream(new FileInputStream(file));
            OutputStream os = socket.getOutputStream();
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
    }

    public void upload_server(String uploadDir, String fileToUpload){
        try {
            FileOutputStream fos = new FileOutputStream(uploadDir + "\\" + fileToUpload);
            long size = dis.readLong();
            byte[] data = new byte[1024];
            int byteContent;
            while (size > 0 && ((byteContent = dis.read(data, 0, (int)Math.min(data.length, size))) > 0)) {
                fos.write(data, 0, byteContent);
                //fos.flush();
                size -= byteContent;
            }
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void upload_client(File file){
        try {
            BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
            byte[] data = new byte[1024];
            System.out.println(file.length());
            dos.writeLong(file.length());
            int byteContent;
            while ((byteContent = bis.read(data)) > 0) {
                dos.write(data, 0, byteContent);
                dos.flush();
            }
            bis.close();
            dos.close();
            System.out.println("File sent to server.");
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}