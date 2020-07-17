import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class Main {
    public static void main(final String[] args) {
        String csvFile = "/Users/etiennecosta/Desktop/Universidade/SRCR/Trabalho/SRCR[3]-A76089/Parser/list.csv";
        String line = null;
        boolean nextLine = true;

        try {
            BufferedReader br = new BufferedReader(new FileReader(csvFile));
            FileOutputStream out = new FileOutputStream("/Users/etiennecosta/Desktop/Universidade/SRCR/Trabalho/SRCR[3]-A76089/adjacentes.pl");
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(out));

            br.readLine();

            while ((line = br.readLine()) != null) {
                if(line.length() == 0) continue;
                nextLine = true;
                String[] parameters = line.split(";");
                if(parameters[0].equals("gid")) {
                    continue;
                }
                Structure newObject = new Structure();
                newObject.gid = Integer.parseInt(parameters[0]);
                newObject.latitude = Double.parseDouble(parameters[1]);
                newObject.longitude = Double.parseDouble(parameters[2]);
                newObject.status = parameters[3];
                newObject.abrigo = parameters[4];
                newObject.publicity = parameters[5];
                newObject.operator = parameters[6];
                newObject.code = Integer.parseInt(parameters[8]);
                
                newObject.address = parameters[9];
                if (parameters.length == 11)
                    newObject.parish = parameters[10];

                String[] values = parameters[7].split(",");
                if (values.length == 1) {
                    newObject.point = Integer.parseInt(values[0]);
                    bw.write(newObject.print());
                } else {
                    for (int i = 0; i < values.length; i++) {
                        newObject.point = Integer.parseInt(values[i]);
                        bw.write(newObject.print());
                        bw.newLine();
                        nextLine = false;
                    }
                }

                if (nextLine)
                    bw.newLine();
                out.flush();
            }
            br.close();
            bw.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

class Structure {
    int gid;
    int point;
    double latitude;
    double longitude;
    String status;
    String abrigo;
    String publicity;
    String operator;
    int code;
    String address;
    String parish;

    public Structure() {
        this.gid = 0;
        this.point = 0;
        this.latitude = 0;
        this.longitude = 0;
        this.status = "";
        this.abrigo = "";
        this.publicity = "";
        this.operator = "";
        this.code = 0;
        this.address = "";
        this.parish = "";
    }

    public String print() {
        return "paragem(" + this.gid + "," + this.point + "," + this.latitude + "," + this.longitude + ",'" + this.status
                + "'," + "'" + this.abrigo + "'," + "'" + this.publicity + "'," + "'" + this.operator + "'," + this.code
                + "," + "'" + this.address + "'," + "'" + this.parish + "').";
    }
}