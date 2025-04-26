/* Initial beliefs, rules and inferences */

// beliefs: idioma(), cumprimento(,)

/* Initial goals */

/* Initial plans */

+mensagem(Msg)[source(Fonte)] <- !responder(Msg, Fonte).

+!responder(Msg, Destinatario): cumprimento(Idioma, Msg) <- .print(Msg);
    .send(Destinatario, tell, mensagem(Msg));
    -mensagem(Msg)[source(Destinatario)].

// Fallback que garante a resposta na lingua nativa do agente
+!responder(Msg, Destinatario): idioma(Idioma) & cumprimento(Idioma, Cumprimento) <- .print(Cumprimento);
    .send(Destinatario, tell, mensagem(Cumprimento));
    -mensagem(Msg)[source(Destinatario)].
    
+!learn(Idioma, Cumprimento) <- .print("Learning: ", Idioma);
    +cumprimento(Idioma, Cumprimento).
