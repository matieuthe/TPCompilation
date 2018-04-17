import java.io.*;
class Utilitaire{
    public static Utilitaire INSTANCE = new Utilitaire();
    private int value;
    private String res;
    private boolean comment;
    
    private Utilitaire(){
        value = 0;
        res = "";
        comment = false;
    }
    
    public void printStart(){
        String init = "<HTML> <BODY bgcolor=\"#FFFFFF\">\n";
        init += "<H2>main.c</H2>\n";
        init += "<CODE>";
        res+= init;
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
    }
    
    private void printFont(String value, String color, boolean br){
        if(comment){
            res += " " + value;
        }else{
            String brEnd = "";
            if(br) brEnd = "<BR>";
            String fontRes = "\n<FONT COLOR=\"" + color + "\">" + value + "</FONT>" + brEnd;
            res += fontRes;
        }
    }
    
    public void printOtherText(String value, boolean br){
        if(comment){
            res += " " + value;
        }else{
            String line = value;
            if(br) line += "<BR>";
            res+=line;
        }
    }
    
    public void printBR(){
        res += "<BR>";
    }
    
    public void startComment(){
        comment = true;
        res += "\n<FONT COLOR=\"#C0C0C0\">/*";
    }
    
    public void endComment(){
        comment = false;
        res += " */</FONT><BR>";
    }
    
    public void printKeyWord(String value){
        printFont(value, "#0000FF", false);
    }
    
    public void printInclude(String value){
        printFont("#include &lt;" + value + "&gt;", "#00FF00", true);
    }
    
    public void printOneLineComment(String value){
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
oneLineComment = \s*\/\/.*
startComment = \s*\/\*.*
endComment = \s*\*\/.*

%%
{keyWord} {
    String line = yytext().trim();
    int endLine = line.indexOf('\n');
    int space = line.indexOf(' ');
    int parental = line.indexOf('(');
    if(space == -1) space = 10000;
    if(endLine == -1) endLine = 10000;
    if(parental == -1) parental = 10000;    
    if(space > parental && endLine > parental){
        yypushback(line.length() - parental);
        Utilitaire.INSTANCE.printKeyWord(line.substring(0,parental));
    } 
    else if(endLine > space){
        yypushback(line.length() - space);
        Utilitaire.INSTANCE.printKeyWord(line.substring(0,space));
    }else if(endLine != 10000){
        yypushback(line.length() - endLine);
        Utilitaire.INSTANCE.printKeyWord(line.substring(0,endLine));
        Utilitaire.INSTANCE.printBR();
    }else{
        Utilitaire.INSTANCE.printKeyWord(line);
        Utilitaire.INSTANCE.printBR();
    }
}

{inclusion} {
    String name = yytext();
    int deb = name.indexOf("<");
    int fin = name.indexOf(">");
    name = name.substring(deb+1,fin);
    Utilitaire.INSTANCE.printInclude(name);
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

{oneLineComment} {
    String line = yytext().trim();
    Utilitaire.INSTANCE.printOneLineComment(line);
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