%%
%class exo2
%standalone

nbIP = (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])
ip_address = ({nbIP}"."){3}{nbIP}

scheme = (ftp|https?|gopher|nntp):

escape = %[0-9]+
id = [A-Za-z0-9]|{escape}
extension = [A-Za-z]+

domain = (www".")?({id}"."?)+{extension}+
portNumber = ":"[0-9]{2,4}
arobase = "#"[A-Za-z0-9]+

first_part = ({domain}|{ip_address}){portNumber}?
second_part = (\/(({id}+\/)*({id}+"."[A-Za-z]+{arobase}?)?)?)?

address = {scheme}\/\/{first_part}{second_part}

%%
{address} {
    System.out.println("Address : " + yytext());
}

.* {
    System.out.println("Incorrect : " + yytext());
}