%%
%class exo1
%standalone

i_d = [a-zA-Z0-9]+
username = ({i_d}"."?)+
domain_name = {i_d}
extension = ("."{i_d})+
email = {username}@{domain_name}{extension}
test = test(ab|ac)*

%%
{email} {
    System.out.println("Email : " + yytext());
}
{test} {
    System.out.println("Test ok : " + yytext());
}
.* {
    System.out.println("Not an email : " + yytext());
}