import java.io.*;
%%
%class exo1
%standalone
%init{
    String init = "<HTML> <BODY bgcolor=\"#FFFFFF\">\n";
    init += "<H2>main.c</H2>\n";
    init += "<CODE>";
    System.out.println(init);

%init}
%eof{
    String fin = "</CODE></BODY></HTML>";
    System.out.println(fin);
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
        System.out.println("<FONT COLOR=\"#0000FF\">" + line.substring(0,parental) + "</FONT>");
    } 
    else if(space != -1){
        yypushback(line.length() - space);
        System.out.println("<FONT COLOR=\"#0000FF\">" + line.substring(0,space) + "</FONT>");
    } 
}
{inclusion} {
    String name = yytext();
    int deb = name.indexOf("<");
    int fin = name.indexOf(">");
    name = name.substring(deb+1,fin);
    System.out.println("<FONT COLOR=\"#00FF00\">#include &lt;" + name + "&gt;</FONT><BR>");
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
    System.out.println("<FONT COLOR=\"#C0C0C0\">" + line.substring(deb,fin) + "</FONT><BR>");
}

{number} {
    String line = yytext().trim();
    int fin = -1;
    for(int i = 0; i < line.length(); i++){
        if(line.charAt(i) < '0' || line.charAt(i) > '9') i = line.length();
        else fin = i;
    }
    System.out.println("<FONT COLOR=\"#FF0000\">" + line.substring(0,fin+1) + "</FONT>");
    yypushback(line.length() - (fin+1));
}

.* {
    String line = yytext().trim();
    int nextSpace = line.indexOf(' ');
    if(nextSpace == -1) nextSpace = line.length();
    int indice = -1;
    for(int i = 0; i < nextSpace; i++){
        if(line.charAt(i) <= '9' && line.charAt(i) >= '0'){
            indice = i;
            i = nextSpace;
        }else if(line.charAt(i) == '(' || line.charAt(i) == ')'){
            indice = i + 1;
            i = nextSpace;
        }
    }
    if(indice != -1){
        System.out.println(line.substring(0,indice));
        yypushback(line.length() - indice);
    }else{
        if(line.indexOf(' ') == -1){
            System.out.println(line + "<BR>");
        }else{
            yypushback(line.length() - nextSpace);
            System.out.println(line.substring(0,nextSpace));
        }
    }
}