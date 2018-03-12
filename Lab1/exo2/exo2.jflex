%%
%class exo2
%standalone
number = [0-9]+
float = {number}"."{number}
integer = {number}
operand = [-+]*({integer}|{float})
function_name = [a-zA-Z]+
id = {function_name}\({operand}\,{operand}\)

%%
{id} { 
    String line = yytext();
    int indice = line.indexOf('(');
    String functionName = line.substring(0,indice);
    int indiceVirg = line.indexOf(',');
    float number1 = Float.valueOf(line.substring(indice + 1, indiceVirg));
    float number2 = Float.valueOf(line.substring(indiceVirg +1 , line.length() - 1));
    
    float res = 0;
    if(functionName.equals("add")){
        res = number1 + number2;
    }else if(functionName.equals("minus")){
        res = number1 - number2;
    }else if(functionName.equals("multi")){
        res = number1 * number2;
    }
    System.out.println(line + " = " + res);
}

.* {
    System.out.println("Not a valid operation : " + yytext());
}