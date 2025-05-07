

/* Plans */
+tarefa(T,MaxVal): decremento(D,T)
    <-  .print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
        .broadcast(tell,oferta(T,MaxVal-D)).

+oferta(T,Val): bid_minimo(Min,T) & decremento(D,T) & (Val-D >= Min)
    <-  //.print("Vou cobrir a oferta de ", Val, " com ", Val-D, " para a tarefa ", T);
        //.wait(200);
        .broadcast(tell,oferta(T,Val-D)).

+oferta(T,Val): bid_minimo(Min,T) & decremento(D,T) & (Val-D <= Min)
    <-  .print("Vou ficar de fora da tarefa ", T, " pois o valor jah estah em ", Val, " e o meu minimo eh ", Min).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }