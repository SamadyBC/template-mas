/* Initial beliefs, rules and inferences */

  //idioma(), cumprimento()

  // beliefs: idioma("Ingles"), cumprimento("Ingles", "Hello")

/* Initial goals */

// !comunicar. Como esse objetivo eh adicionado na declaracao do agente

/* Initial plans */
/*
+consultar(Receiver, Produto)
    <- .send(Receiver, askOne, valor(Produto, X), A);
    .print(A).
    
+valor(Produto, X) <- .print("Recebi a informacao ", valor(Produto, X))

+!dizer(X,S) <- .send(S, achieve, X).


!ola.

+!ola <- .print("Oi").
*/

+mensagem(X)[source(Fonte)]: idioma(I) <-
    //.print("Broadcast recebido de: ", Fonte);
    //.print("Mensagem: ", X);
    !responder(I, Fonte).

+!responder(Idioma, Destinatario): cumprimento(Idioma, Cumprimento) <- .print(Cumprimento);
    .send(Destinatario, tell, mensagem(Cumprimento)).
    
+!learn(Idioma) <- .print("Learning: ", Idioma);
    +idioma(Idioma);
    +cumprimento(Idioma, "Ola").





/*
+!dizer(Info, Receiver)
<- .send(Receiver, tell, Info).

+!pedir_valor(Produto, Fonte): .my_name(Nome)
    <- .send(Fonte, achieve, dizer(preco(Produto, 10), Nome)).

// Reage a adicao de uma crenca
+preco(Produto, Valor)[source(Fonte)] <- .print("Recebi a informacao do valor ", Valor, "do produto ", Produto);
.print("Recebi essa informacao de ", Fonte);
.send(Fonte, tell, muito_caro(Produto).)*/