import java.io.*;
import java.util.*;

class Utilitaire{
    public static Utilitaire INSTANCE = new Utilitaire();
    private String res;
    private boolean comment;
    private Map<String,Integer> _associations;
    private String currentSentence;
    private int tagNumbers; 
    
    private Utilitaire(){
        res = "";
        comment = false;
        currentSentence = "";
        tagNumbers = 0;
        this._associations = new HashMap<>();
        this._associations.put("TABLE", 0);
        this._associations.put("H1", 0);
        this._associations.put("H2", 0);
        this._associations.put("H3", 0);
        this._associations.put("H4", 0);
    }
    
    public void countTag(String typeTag){
        if(!comment){
            String tag = typeTag.trim();
            tagNumbers++;
            //To find the tag with parameter like table or image
            int indexSpace = tag.indexOf(" ");
            if(indexSpace != -1){
                tag = tag.substring(0, indexSpace);
            }
            
            //To find closing tag
            int indexSlash = tag.indexOf("/");
            if(indexSlash != -1){
                tag = tag.substring(1, tag.length());
            }
            
            //Update the number of TAG in the map
            String key = tag.toUpperCase();
            if(this._associations.get(key) != null){
                this._associations.put(key, this._associations.get(key) + 1);
            }
            res += "<"+ typeTag +">";
        }
    }
    
    public void startComment(){
        this.comment = true;
    }
    
    public void endComment(){
        this.comment = false;
    }
    
    public boolean isComment(){
        return this.comment;
    }
    
    public void copyToFile(){
        File f = new File("save.txt");
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
    
    public void printRes(){
        System.out.println("------------ Output ------------");
        System.out.println(res);
        System.out.println("Tags :" + this.tagNumbers);
        System.out.println("table :" + this._associations.get("TABLE"));
        System.out.println("H1 :" + this._associations.get("H1"));
        System.out.println("H1 :" + this._associations.get("H1"));
        System.out.println("H2 :" + this._associations.get("H2"));
        System.out.println("H3 :" + this._associations.get("H3"));
        System.out.println("H4 :" + this._associations.get("H4"));
    }
    
    public void print(String value){
        if(!comment)
            res+= value;
    }
    
    public void testCurrent(String value){
        if(!currentSentence.contains(value)){
            res+= "\n";
            currentSentence = value;
        }
    }
}


%%
%class exo2
%standalone
%eof{
    Utilitaire.INSTANCE.copyToFile();
    Utilitaire.INSTANCE.printRes();
%eof}

startComment = \s*\<\!\-\-.*
endComment = .*\-\-\>.*
tag = .*\<.*\>.*

%%

{startComment} {
    String line = yytext().trim();

    Utilitaire.INSTANCE.startComment();
    yypushback(line.length() - 4);
}

{endComment} {
    String line = yytext().trim();
    Utilitaire.INSTANCE.endComment();
    int pos = 0;
    while(line.charAt(pos) != '-' && line.charAt(pos+1) != '-' && line.charAt(pos+2) != '>')
        pos++;
    yypushback(line.length() - (pos+2));
}

{tag} {
    if(!Utilitaire.INSTANCE.isComment()){
        String line = yytext().trim();
        Utilitaire.INSTANCE.testCurrent(line);
        if(line.charAt(0) != '<'){
            int pos = 1;
            while(line.charAt(pos++) != '<');
            Utilitaire.INSTANCE.print(line.substring(0,pos-1));
            yypushback(line.length() - (pos-1));
        }else{
            int pos = 2;
            while(line.charAt(pos) != '>')
                pos++;
            Utilitaire.INSTANCE.countTag(line.substring(1,pos));
            yypushback(line.length() - (pos+1));
        }
    }
}