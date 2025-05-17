/* Initial beliefs, rules and inferences */
// Alterar variaveis: C -> Graus, X -> Cultivo
reduzir_temperatura(Graus) :- temp_atual(Temp_Atual) & temp_ideal(Temp_Ideal) & Temp_Atual > Temp_Ideal & Graus = Temp_Atual - Temp_Ideal.
aumentar_temperatura(Graus) :- temp_atual(Temp_Atual) & temp_ideal(Temp_Ideal) & Temp_Atual < Temp_Ideal & Graus = Temp_Ideal - Temp_Atual.
temperatura_estavel(Graus) :- temp_atual(Temp_Atual) & temp_ideal(Temp_Ideal) & Temp_Atual == Temp_Ideal & Graus = Temp_Ideal.

/* Initial goals */
// !regularTemperatura. Como esse objetivo eh adicionado na declaracao do agente, entao nao ha necessidade de adicionar aqui

/* Initial plans */

+!regular_temperatura
    <- .print("Regular temperatura caso 1");
    !verificar_temp.
    //.wait(5000);
    //!regular_temperatura(Local).

+!regular_temperatura: not temp_atual(Teste1) & temp_ideal(Teste2) <- .print("Regular temperatura caso padrao").

+!verificar_temp: reduzir_temperatura(C) <- .print("Reduzir a temperatura em: ", C, " graus celsius.");
    !resfriar(C).

+!verificar_temp: aumentar_temperatura(C) <- .print("Aumentar a temperatura em: ", C, " graus celsius.");
    !aquecer(C).

+!verificar_temp: temperatura_estavel(C) <- .print("Temperatura ideal atingida em: ", C, " graus celsius.").

//+!verificar_temp: not temp_atual(Temp_Atual) <- .print("Sem informacao da temperatura atual").

+!aquecer(C): temp_atual(Temp) <- .print("Aquecendo");
    .wait(1000);
    -temp_atual(Temp);
    +temp_atual(Temp + C);
    .print("Temperatura estabilizada").
    //Aqui havera modificacao do ambiente devido a estabilizacao da temperatura.

+!resfriar(C): temp_atual(Temp) <- .print("Resfriando");
    .wait(1000);
    -temp_atual(Temp);
    +temp_atual(Temp - C);
    .print("Temperatura estabilizada").
    //Aqui havera modificacao do ambiente devido a estabilizacao da temperatura.

// Planos de Comunicao: 

/* 1. Receber comando do gerenciador */
//Como meu controlador possui na sua base de crencas as informacoes do local e cultivo bem como do cultivo e da temperatura ideal. As unicas informacoes necessarias da mensagem do gerenciador eh temperatura e local

+!ajustar_temperatura(Temp_Atual, Temp_Ideal): not temp_atual(_) & not temp_ideal(_)
    <- .print("Primeiro comando recebido do Gerenciador");
    .print("Temperatura atual: ", Temp_Atual, " graus");
    .print("Temperatura ideal: ", Temp_Ideal, " graus");
    +temp_atual(Temp_Atual);
    +temp_ideal(Temp_Ideal);
    !executar_comando.

+!ajustar_temperatura(Temp_Atual, Temp_Ideal): temp_atual(TA) & temp_ideal(TI)
    <- .print("Comando recebido do Gerenciador");
    .print("Temperatura atual recebida: ", Temp_Atual, " - Temperatura Atual Armazenada: ", TA);
    .print("Temperatura ideal recebida: ", Temp_Ideal, " - Temperatura Ideal Armazenada: ", TI);
    if (Temp_Atual \== TA){
        -temp_atual(TA);
        +temp_atual(Temp_Atual);
    };
    if(Temp_Ideal \== TI){
        -temp_ideal(TI);
        +temp_ideal(Temp_Ideal);
    };
    !executar_comando.

+!executar_comando: temp_atual(Teste1) & temp_ideal(Teste2) 
    <- .print("Proxima etapa: regular temp");
    !regular_temperatura; // Verificar a necessidade de enviar o local junto ao comando de estabilizacao de temperatura
    .send(gerenciador_ambiente, tell, status_temp("Estabilizado")).

+!executar_comando <- .print("nao contem informacao de ta e ti").
/* 2. Executar comando recebido 
+!executar_comando(C, Temp_Ideal): not temp_atual(_) <-
    .print("Inicialmente sem informacao de Temperatura");
    +temp_atual(C);
    !regular_temperatura(Local);
    .send(gerenciador_ambiente, tell, status_temperatura(Local, "Estabilizado")).


+!executar_comando(C, Temp_Ideal): temp_atual(TA) & TA \== C <-
    .print("Temperatura medida", C, " Temperatura armazenada", TA);
    -temp_atual(TA);
    +temp_atual(C);
    !regular_temperatura(Local);
    .send(gerenciador_ambiente, tell, status_temperatura(Local, "Estabilizado")).

+!executar_comando(C, Temp_Ideal): temp_atual(TA) & TA == C <-
    .print("Temperatura já estável em ", Local);
    .send(gerenciador_ambiente, tell, temperatura_estavel(Local, Cultivo, C)).

/* 3. Exemplo para enviar status periódico ao gerenciador 
+!reportar_status(Local, Cultivo) : temp_atual(Temp) <-
    .print("Enviando status ao Gerenciador: Temp atual ", Temp);
    .send(gerenciador_ambiente, tell, status_temp(Local, Cultivo, Temp)).

/* 4. Receber pedidos de status 
+?status_temperatura(Local, Cultivo) : true <-
    !reportar_status(Local, Cultivo).
    */