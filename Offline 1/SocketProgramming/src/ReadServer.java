import java.io.*;
import java.util.Date;

public class ReadServer implements Runnable{
    private static int numberOfRequests = 0;
    private Thread thr;
    private NetworkUtil networkUtil;
    private int port;
    private String root;
    private String log;
    private String upload;

    public ReadServer(NetworkUtil networkUtil, int port, String root, String log, String upload) {
        this.networkUtil = networkUtil;
        this.port = port;
        this.root = root;
        this.log = log;
        this.upload = upload;
        this.thr = new Thread(this);
        thr.start();
    }

    @Override
    public void run() {
        String input;
        PrintWriter fw;
        while(true) {
            try {
                input = networkUtil.read();
                fw = new PrintWriter(log + "\\log" + numberOfRequests + ".log");
                numberOfRequests++;
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }

            if (input == null) {
                System.out.println("Client disconnected");
                fw.close();
            } else {
                StringBuilder path = new StringBuilder();
                String[] tokens = input.split("/");
                File file;
                File[] listOfFiles;

                for (int i = 1; i < tokens.length - 1; i++) {
                    if (i == (tokens.length - 2)) {
                        path.append(tokens[i].replace(" HTTP", ""));
                    } else {
                        path.append(tokens[i]).append("\\");
                    }
                }

                if (path.toString().equals("")) {
                    file = new File(root);
                } else {
                    path = new StringBuilder(path.toString().replace("%20", " ") + "\\");
                    file = new File(root + "\\" + path);
                }

                StringBuilder content = new StringBuilder("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><link rel=\"icon\" href=\"data:,\"></head>");

                if (file.exists()) {
                    if (file.isDirectory()) {
                        listOfFiles = file.listFiles();
                        content.append("<body><h4>Showing Directory</h4><br><br>");

                        for (File entry : listOfFiles) {
                            String url = "http://localhost:" + port + "/" + path.toString().replace("\\", "/") + entry.getName();
                            if (entry.isDirectory()) {
                                content.append("<b><i><a href=\"").append(url).append("\">").append(entry.getName()).append("</a></b></i><br>\n");
                            } else if (entry.isFile()) {
                                content.append("<a href=\"").append(url).append("\">").append(entry.getName()).append("</a><br>\n");
                            }
                        }
                        content.append("</body>\n</html>");
                    }
                } else {
                    content.append("<body><h1>ERROR 404\n Not Found! </h1><br><br></body>\n</html>");
                }
                if (input.startsWith("GET")) {
                    String response = "HTTP Request : ";
                    response += input + "\n";
                    response += "---------------------------------------------------------------\n";
                    response += "HTTP Response : \n";

                    if (file.isFile()) {
                        String extension = file.getName().split("\\.")[1];
                        content = new StringBuilder("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><link rel=\"icon\" href=\"data:,\"></head>");
                        response += "HTTP/1.1 200 OK;\r\n" +
                                "Server: Java HTTP Server: 1.0;\r\n" +
                                "Date: " + new Date() + ";\r\n";

                        if (extension.equals("txt")) {
                            try {
                                content.append("<body><p>");

                                FileReader fileReader = new FileReader(file);
                                BufferedReader bufferedReader = new BufferedReader(fileReader);
                                String line;
                                while ((line = bufferedReader.readLine()) != null) {
                                    content.append(line).append("<br>");
                                }
                                fileReader.close();
                                content.append("</p></body></html>");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            response += "Content-Type: text/html;\r\n" +
                                    "Content-Length: " + content.length() + ";\r\n\r\n";
                            fw.println(response);
                            networkUtil.printWrite(response);
                            networkUtil.printWrite(content.toString());
                            networkUtil.printWrite("\r\n");

                        } else if (extension.equals("jpg") || extension.equals("jpeg") || extension.equals("png")) {
                            byte[] data = new byte[(int) file.length()];
                            response += "Content-Type: image/" + extension + ";\r\n" +
                                    "Content-Length: " + data.length + ";\r\n\r\n";
                            fw.println(response);
                            networkUtil.printWrite(response);
                            networkUtil.download(file, data);
                        } else {
                            response += "Content-Type: application/force-download;\r\n" +
                                    "Content-Disposition: attachment;" +
                                    "Content-Length: " + content.length() + ";\r\n\r\n";
                            fw.println(response);
                            networkUtil.printWrite(response);
                            byte[] data = new byte[1024];
                            networkUtil.download(file, data);
                        }
                    } else if (file.isDirectory()) {
                        response += "HTTP/1.1 200 OK\r\n" +
                                "Server: Java HTTP Server: 1.0\r\n" +
                                "Date: " + new Date() + "\r\n" +
                                "Content-Type: text/html\r\n" +
                                "Content-Length: " + content.length() + "\r\n\r\n";
                        fw.println(response);
                        networkUtil.printWrite(response);
                        networkUtil.printWrite(content.toString());
                        networkUtil.printWrite("\r\n");
                    } else {            //not found
                        response = "HTTP/1.1 404 NOT FOUND\r\n" +
                                "Server: Java HTTP Server: 1.0\r\n" +
                                "Date: " + new Date() + "\r\n" +
                                "Content-Type: text/html\r\n" +
                                "Content-Length: " + content.length() + "\r\n\r\n";
                        fw.println(response);
                        networkUtil.printWrite(response);
                        networkUtil.printWrite(content.toString());
                        networkUtil.printWrite("\r\n");
                    }
                } else if (input.startsWith("UPLOAD")) {
                    String msg = networkUtil.read();
                    if (msg.equals("fileOkay")) {
                        String fileToUpload = input.substring(7);
                        String extension = fileToUpload.split("\\.")[1];
                        if (extension.equals("txt") || extension.equals("jpg") || extension.equals("png") || extension.equals("mp4")) {
                            networkUtil.upload_server(upload, fileToUpload);
                            System.out.println("File " + fileToUpload + " uploaded successfully!");
                        } else {
                            networkUtil.printWrite("Invalid File Format");
                        }
                    } else {
                        networkUtil.printWrite("Couldn't Upload File");
                    }
                    break;
                }
                fw.close();
            }
        }
    }
}
