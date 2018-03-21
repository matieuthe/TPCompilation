%%
%class exo2
%standalone

nb_ip = ((25[0–5])|(2[0–4][0–9])|([01]?[0–9][0–9]?))
ip_address = {nb_ip}

%%
{ip_address} {
    System.out.println("IP");
}

.* {
    System.out.println("Incorrect");
}