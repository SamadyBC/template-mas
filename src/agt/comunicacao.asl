+consultar(Receiver, Produto)
    <- .send(Receiver, askOne, valor(Produto, X), A);
    .print(A).
+valor(Produto, X) <- .print("Recebi a informacao ", valor(Produto, X))

+!dizer(X,S) <- .send(S, achieve, X).

+ola[source(F)] <- .print("Ola").

+!dizer(Info, Receiver)
<- .send(Receiver, tell, Info).

+!pedir_valor(Produto, Fonte): .my_name(Nome)
    <- .send(Fonte, achieve, dizer(preco(Produto, 10), Nome)).

// Reage a adicao de uma crenca
+preco(Produto, Valor)[source(Fonte)] <- .print("Recebi a informacao do valor ", Valor, "do produto ", Produto);
.print("Recebi essa informacao de ", Fonte);
.send(Fonte, tell, muito_caro(Produto).)