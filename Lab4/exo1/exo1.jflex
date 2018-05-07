import java.io.*;
import java.util.*;

class Utilitaire{
    public static Utilitaire INSTANCE = new Utilitaire();
    private int value;
    private String res;
    private boolean comment;
    private Map<String,String> _associations;
    
    private Utilitaire(){
        value = 0;
        res = "";
        comment = false;
        
        this._associations = new HashMap<>();
        
        this._associations.put("double", "DOUBLE_TYPE");
        this._associations.put("int", "INT_TYPE");
        this._associations.put("while", "WHILE");
        this._associations.put("[", "BO");
        this._associations.put("]", "BC");
        this._associations.put(";", "SCL");
        this._associations.put(";", "SCL");
        this._associations.put("=", "EQ");
        this._associations.put("-", "MIN");
        this._associations.put("+", "PLUS");
        this._associations.put("(", "PO");
        this._associations.put(")", "PC");
        this._associations.put("{", "CBO");
        this._associations.put("}", "CBC");
        this._associations.put(",", "COM");
        this._associations.put(">", "BIG");
        this._associations.put("<", "SML");     
    }
    
    public void getSpecial(String value){
        if(!comment){
            String corres = this._associations.get(value.trim());
            if(corres == null){
                corres = "ID:" + value;
            }
            res+= corres + " ";
            System.out.println(corres);
        }
    }
    
    public void printInteger(String value){
        res+= "INT:" + value + " ";
        System.out.println("INT:" + value);
    }
    
    public void printDouble(String value){
        res+= "INT:" + value + " ";
        System.out.println("DOUBLE:" + value);
    }
    
    public void startComment(){
        this.comment = true;
    }
    
    public void endComment(){
        this.comment = false;
    }
    
    public void copyToFile(){
        File f = new File("save.html");
		FileWriter fiWri = null;
		BufferedWriter buffWri = null;
		
		try {
			fiWri = new FileWriter(f);
			buffWri = new BufferedWriter(fiWri);
			buffWri.write(res);
			buffWri.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				if(fiWri != null){ 
					fiWri.close();
				}
				if(buffWri != null){
					buffWri.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
    }
}


%%
%class exo1
%standalone
%eof{
    Utilitaire.INSTANCE.copyToFile();
%eof}

startComment = \s*\/\*.*
endComment = \s*\*\/.*
integer = \s*[0-9]+[^\.]+.*
double = \s+[0-9]+\.[0-9]+.*


%%

{double} {
    String line = yytext().trim();
    int pos = 0;
    if(line.charAt(pos+1) > '0' && line.charAt(pos+1) < '9')
        pos++;
    pos++; //Point position
    pos++;
    if(line.charAt(pos+1) > '0' && line.charAt(pos+1) < '9')
        pos++;

    Utilitaire.INSTANCE.printDouble(line.substring(0,pos+1));
    yypushback(line.length() - (pos+1));
}

{integer} {
    String line = yytext().trim();
    int pos = 0;
    if(line.charAt(pos+1) > '0' && line.charAt(pos+1) < '9')
        pos++;
    Utilitaire.INSTANCE.printInteger(line.substring(0,pos+1));
    yypushback(line.length() - (pos+1));

}

{startComment} {
    String line = yytext().trim();
    Utilitaire.INSTANCE.startComment();
    yypushback(line.length() - 2);
}

{endComment} {
    String line = yytext().trim();
    Utilitaire.INSTANCE.endComment();
    yypushback(line.length() - 2);
}

.* {
    String line = yytext().trim();
    if(line != ""){
        int pos = 0;
        if((line.charAt(pos) <= 'z' && line.charAt(pos) >= 'a') ||  (line.charAt(pos) <= 'Z' && line.charAt(pos) >= 'A')){
            while( (pos+1) < line.length() && ((line.charAt(pos+1) <= 'z' && line.charAt(pos+1) >= 'a') ||  (line.charAt(pos+1) <= 'Z' && line.charAt(pos+1) >= 'A') ) ){
                pos++;
            }   
        }
        Utilitaire.INSTANCE.getSpecial(line.substring(0,pos+1));
        //System.out.println(line.substring(0,pos+1));
        yypushback(line.length() - (pos+1));
    }
}