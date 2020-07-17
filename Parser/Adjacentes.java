import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class Adjacentes {
    public static void main(final String[] args) {
        String csvFile = "/Users/etiennecosta/Desktop/Universidade/SRCR/Trabalho/SRCR[3]-A76089/Parser/list.csv";
        String line = null, line2 = null;
        boolean nextLine = true;

        try {
            BufferedReader br = new BufferedReader(new FileReader(csvFile));
            FileOutputStream out = new FileOutputStream("/Users/etiennecosta/Desktop/Universidade/SRCR/Trabalho/SRCR[3]-A76089/adjacente.pl");
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(out));

            while((line = br.readLine()) != null) {
                br.mark(146);

                line2 = br.readLine();

                if(line.length() == 0 || line2 == null || line.length() != 0 && line2.length() == 0) {
                    br.reset();
                    continue;
                }
                
                String[] parameters = line.split(";");
                String[] parametersNext = line2.split(";");

                if(parameters[0].equals("gid")) {
                    br.reset();
                    continue;
                }

                Structure objectOne = new Structure();
                double latitude = Double.parseDouble(parameters[1]);
                double longitude = Double.parseDouble(parameters[2]);
                
                double nextLatitude = Double.parseDouble(parametersNext[1]);
                double nextLongitude = Double.parseDouble(parametersNext[2]);
                int adjacente = Integer.parseInt(parametersNext[0]);

                double distancia = 0.001* Math.sqrt( Math.pow((nextLatitude - latitude),2)  + Math.pow((nextLongitude-longitude),2));
                distancia = (double)Math.round(distancia * 10000d) / 10000d;

                objectOne.gid = Integer.parseInt(parameters[0]);
                objectOne.adjacente = adjacente;
                objectOne.distancia = distancia;
                objectOne.estado = parameters[3];
                objectOne.abrigo = parameters[4];
                objectOne.publicidade = parameters[5];
                objectOne.operadora = parameters[6];
                objectOne.carreira = Integer.parseInt(parameters[7]);
                objectOne.codigo = Integer.parseInt(parameters[8]);
                objectOne.rua = parameters[9];
                if(parameters.length >= 11) objectOne.freguesia = parameters[10];

                bw.write(objectOne.print());

                br.reset();
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
    int carreira;
    int adjacente;
    double distancia;
    String estado;
    String abrigo;
    String publicidade;
    String operadora;
    int codigo;
    String rua;
    String freguesia;

    public Structure() {
        this.gid = 0;
        this.adjacente = 0;
        this.carreira = 0;
        this.distancia = 0;
        this.estado = "";
        this.abrigo = "";
        this.publicidade = "";
        this.operadora = "";
        this.codigo = 0;
        this.rua = "";
        this.freguesia = "";
    }

    public String print() {
        return "adjacente("+this.carreira +"," + this.gid + "," + this.adjacente + "," + this.distancia + ",'" + this.estado
                + "'," + "'" + this.abrigo + "'," + "'" + this.publicidade + "'," + "'" + this.operadora + "'," + this.codigo
                + "," + "'" + this.rua + "'," + "'" + this.freguesia + "').\n";
    }
}