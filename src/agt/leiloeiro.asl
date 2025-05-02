// Agent sample_agent in project main

/* Initial beliefs and rules */


/* Initial goals */

/* Plans */
+!anunciar_tarefa(T,MaxVal) <- .broadcast(tell,tarefa(T,MaxVal)).

@p1 [atomic]
+oferta(T,Val)[source(Bider)]: not(vencedor(_,T,_)) 
    <- .print("Primeiro Lance: (",Bider,",",T,",",Val,")");
        +bid(Bider,T,Val);
        +vencedor(Bider,T,Val).

@p2 [atomic]
+oferta(T,Val)[source(Bider)]: vencedor(Name,T,Valor) & (Valor > Val)
    <-  .print("Vencedor anterior: (", Name,",",T,",",Valor,")");
        .print("Vencedor atual: (",Bider,",",T,",",Val,")");
        +bid(Bider,T,Val);
        .abolish(vencedor(_,T,_)[source(self)]);
        +vencedor(Bider,T,Val).

@p3 [atomic]
+oferta(T,Val)[source(Bider)]: vencedor(Name,T,Valor) & Valor < Val
    <-  .print("Ignorando oferta: (",Bider,",",T,",",Val,") pois ela eh maior que anterior: (", Name,",",T,",",Valor,")").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
