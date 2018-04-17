import java.io.*;
class Utilitaire{
    public static Utilitaire INSTANCE = new Utilitaire();
    private int value;
    private String res;

    private Utilitaire(){
        value = 0;
        res = "";        
    }
    
    public void printStart(){
        String init = "<HTML> <BODY bgcolor=\"#FFFFFF\">\n";
        init += "<H2>main.c</H2>\n";
        init += "<CODE>";
        res+= init;
        //System.out.print(init);
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
    
    public void printEnd(){
        String fin = "\n</CODE></BODY></HTML>";
        res+=fin;
        System.out.println(res);
        //System.out.println(fin);
    }
    
    private void printFont(String value, String color, boolean br){
        String brEnd = "";
        if(br) brEnd = "<BR>";
        String fontRes = "\n<FONT COLOR=\"" + color + "\">" + value + "</FONT>" + brEnd;
        res += fontRes;
        //System.out.print(fontRes);
    }
    
    public void printOtherText(String value, boolean br){
        String line = value;
        if(br) line += "<BR>";
        res+=line;
        //System.out.print(line);
    }
    
    public void printKeyWord(String value){
        printFont(value, "#0000FF", false);
        //System.out.print("<FONT COLOR=\"#0000FF\">" + value + "</FONT>");
    }
    
    public void printInclude(String value){
        printFont("#include &lt;" + value + "&gt;", "#00FF00", true);
    }
    
    public void printComment(String value){
        printFont(value, "#C0C0C0", true);
    }
    
    public void printNumber(String value){
        printFont(value, "#FF0000", false);
    }
}


%%
%class exo1
%standalone
%init{
    Utilitaire.INSTANCE.printStart();
%init}
%eof{
    Utilitaire.INSTANCE.printEnd();
    Utilitaire.INSTANCE.copyToFile();
%eof}

keyWord = \s*(int | if | else | return)(\s+|\().*
include = #include
number = \s*[0-9].*
inclusion = #include.*
comment = \s*\/\*.*\*\/.*

%%
{keyWord} {
    String line = yytext().trim();
    int space = line.indexOf(' ');
    int parental = line.indexOf('(');
    if(space > parental && parental != -1){
        yypushback(line.length() - parental);
        Utilitaire.INSTANCE.printKeyWord(line.substring(0,parental));
    } 
    else if(space != -1){
        yypushback(line.length() - space);
        Utilitaire.INSTANCE.printKeyWord(line.substring(0,space));
    } 
}

{inclusion} {
    String name = yytext();
    int deb = name.indexOf("<");
    int fin = name.indexOf(">");
    name = name.substring(deb+1,fin);
    Utilitaire.INSTANCE.printInclude(name);
}

{comment} {
    String line = yytext().trim();
    int deb = -1;
    int fin = -1;
    for(int i = 0; i < line.length() - 2; i++){
        if(line.charAt(i) == '/' && line.charAt(i+1) == '*'){
            deb = i;
            i = line.length();
        }
    }
    for(int i = deb+2; i < line.length() - 1; i++){
        if(line.charAt(i) == '*' && line.charAt(i+1) == '/'){
            fin = i+1;
            i = line.length();
        }
    }
    Utilitaire.INSTANCE.printComment(line.substring(deb,fin));
}

{number} {
    String line = yytext().trim();
    int fin = -1;
    for(int i = 0; i < line.length(); i++){
        if(line.charAt(i) < '0' || line.charAt(i) > '9') i = line.length();
        else fin = i;
    }
    Utilitaire.INSTANCE.printNumber(line.substring(0,fin+1));
    yypushback(line.length() - (fin+1));
}

.* {
    if(yytext().trim() != ""){
        String line = yytext().trim();
        int nextSpace = line.indexOf(' ');
        if(nextSpace == -1) nextSpace = line.length();
        int indice = -1;
        for(int i = 0; i < nextSpace; i++){
            if(line.charAt(i) <= '9' && line.charAt(i) >= '0'){
                indice = i;
                i = nextSpace;
            }else if(line.charAt(i) == '('){
                indice = i + 1;
                i = nextSpace;
            }
        }
        if(indice != -1){
            Utilitaire.INSTANCE.printOtherText(line.substring(0,indice), false);
            yypushback(line.length() - indice);
        }else{
            if(line.indexOf(' ') == -1){
                Utilitaire.INSTANCE.printOtherText(line, true);
            }else{
                yypushback(line.length() - nextSpace);
                Utilitaire.INSTANCE.printOtherText(line.substring(0,nextSpace), false);
            }
        }
    }
}