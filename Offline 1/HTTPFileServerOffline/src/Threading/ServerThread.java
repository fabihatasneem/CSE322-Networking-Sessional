package Threading;

import java.io.*;
import java.net.*;
import java.util.Date;

public class ServerThread implements Runnable {
    private Socket socket;
    private Thread thread;
    private static int numberOfRequests = 1;
    private int port;

    private String root;
    private String log;
    private String upload;

    public ServerThread(Socket socket, int port, String root, String log, String upload) {
        this.socket = socket;
        this.port = port;
        this.root = root;
        this.log = log;
        this.upload = upload;
        thread = new Thread(this);
        thread.start();
    }

    public static String readFileData(File file, int fileLength) throws IOException {
        FileInputStream fileIn = null;
        byte[] fileData = new byte[fileLength];

        try {
            fileIn = new FileInputStream(file);
            fileIn.read(fileData);
        } finally {
            if (fileIn != null)
                fileIn.close();
        }

        return String.valueOf(fileData);
    }

    @Override
    public void run() {
        String input = null;
        BufferedReader br = null;
        PrintWriter pr = null;
        PrintWriter fw = null;

        try {
            br = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"));
            pr = new PrintWriter(socket.getOutputStream());
            input = br.readLine();
            fw = new PrintWriter(log + "\\log" + numberOfRequests + ".log");
            numberOfRequests++;
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (input == null) {
            try {
                br.close();
                pr.close();
                fw.close();
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
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
                            content.append("<b><i><a href=\"" + url + "\">" + entry.getName() + "</a></b></i><br>\n");
                        } else if (entry.isFile()) {
                            content.append("<a href=\"" + url + "\">" + entry.getName() + "</a><br>\n");
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
                    response += "HTTP/1.1 200 OK;\r\n"+
                            "Server: Java HTTP Server: 1.0;\r\n"+
                            "Date: " + new Date() + ";\r\n";

                    if (extension.equals("txt")) {
                        try {
                            content.append("<body><p>");

                            FileReader fileReader = new FileReader(file);
                            BufferedReader bufferedReader = new BufferedReader(fileReader);
                            String line;
                            while ((line = bufferedReader.readLine()) != null) {
                                content.append(line + "<br>");
                            }
                            fileReader.close();
                            content.append("</p></body></html>");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        response += "Content-Type: text/html;\r\n"+
                                "Content-Length: " + content.length() + ";\r\n\r\n";
                        fw.println(response);
                        pr.write(response);
                        pr.write(content.toString());
                        pr.write("\r\n");
                        pr.flush();

                    } else if (extension.equals("jpg") || extension.equals("jpeg") || extension.equals("png")) {
                        String imgUrl = root + "\\" + path;
                        StringBuffer sb = new StringBuffer(imgUrl);
                        sb.delete(imgUrl.length() - 1, imgUrl.length());
                        content.append("<body><img src=\"" + sb + "\"></body></html>");

                        response += "Content-Type: text/html;\r\n"+
                                "Content-Length: " + content.length() + ";\r\n\r\n";
                        fw.println(response);
                        pr.write(response);
                        pr.write(content.toString());
                        pr.write("\r\n");
                        pr.flush();
                    } else {
                        response += "Content-Type: application/force-download;\r\n"+
                                "Content-Disposition: attachment;"+
                                "Content-Length: " + content.length() + ";\r\n\r\n";
                        fw.println(response);
                        pr.write(response);
                        pr.flush();

                        try {
                            BufferedInputStream is = new BufferedInputStream(new FileInputStream(file));
                            OutputStream os = socket.getOutputStream();
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
                    }
                }
                else if(file.isDirectory()){
                    response += "HTTP/1.1 200 OK\r\n"+
                            "Server: Java HTTP Server: 1.0\r\n"+
                            "Date: " + new Date() + "\r\n"+
                            "Content-Type: text/html\r\n"+
                            "Content-Length: " + content.length() + "\r\n\r\n";
                    fw.println(response);
                    pr.write(response);
                    pr.write(content.toString());
                    pr.write("\r\n");
                    pr.flush();
                }
                else {            //not found
                    response = "HTTP/1.1 404 NOT FOUND\r\n"+
                            "Server: Java HTTP Server: 1.0\r\n"+
                            "Date: " + new Date() + "\r\n"+
                            "Content-Type: text/html\r\n"+
                            "Content-Length: " + content.length() + "\r\n\r\n";
                    fw.println(response);
                    pr.write(response);
                    pr.write(content.toString());
                    pr.write("\r\n");
                    pr.flush();
                }
            }
            else if(input.startsWith("UPLOAD")){
                String msg = "";
                try {
                    msg = br.readLine();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                if(msg.equals("fileOkay")){
                    try {
                        String fileToUpload = input.substring(7);
                        System.out.println("fileToUpload : "+fileToUpload);
                        InputStream is = socket.getInputStream();
                        FileOutputStream fos = new FileOutputStream(new File(upload + "\\" + fileToUpload));
                        byte[] data = new byte[1024];
                        int byteContent;
                        while ((byteContent = is.read(data, 0, 1024)) != -1) {
                            fos.write(data, 0, byteContent);
                            fos.flush();
                        }
                        is.close();
                        fos.close();
                        System.out.println("File uploaded successfully!");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else{
                    System.out.println("Couldn't upload file");
                }
            }

            try {
                br.close();
                pr.close();
                fw.close();
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }
}
