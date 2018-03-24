%%
%class exo1
%standalone

drive = [a-zA-Z]
id = [0-9A-Za-z]+
pathName = {id}
fileName = {id}
fileType = {id}
pathFileName = ({drive}:)?\\?({pathName}\\)*{fileName}("."{fileType})?\s*

%%
{pathFileName} {
    System.out.println("Correct : " + yytext()+"\n");
}

.* {
    System.out.println("Incorrect : " + yytext());
}