%%
%class exo1
%standalone

drive = [a-zA-Z]
id = [0-9A-Za-z]+
pathName = {id}
fileName = {id}
fileType = {id}
pathFileName = ({drive}\:)?\\?({pathName}\\)*{fileName}("."{fileType})?\s*

%%
{pathFileName} {
    String fileName = yytext();
    fileName.replace("\\", "\\\\");
    System.out.println("Correct : " + fileName+"\n");
}

.* {
    System.out.println("Incorrect : " + yytext());
}