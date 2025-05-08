/* Initial beliefs, rules and inferences */
// Alterar variaveis: C -> Graus, X -> Cultivo
reduzir_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual > Temp_Ideal & C = Temp_Atual - Temp_Ideal.
aumentar_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual < Temp_Ideal & C = Temp_Ideal - Temp_Atual.
temperatura_estavel(C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual == Temp_Ideal & C = Temp_Ideal.

/* Initial goals */
// !regularTemperatura. Como esse objetivo eh adicionado na declaracao do agente, entao nao ha necessidade de adicionar aqui

/* Initial plans */

+!regular_temperatura(Local): producao(Cultivo, Local) <- .print("Local: ", Local, " - Producao: ", Cultivo);
    !verificar_temp(Local, Cultivo).
    //.wait(5000);
    //!regular_temperatura(Local).

+!regular_temperatura(Local)  <- .print("Caso padrao - Local: ", Local).

+!verificar_temp(Local, Cultivo): reduzir_temperatura(C, Cultivo) & temp_ideal(Cultivo, Temp_Ideal) <- .print("Temperatura Ideal ", Cultivo, ": ", Temp_Ideal, "°C.");
    .print("Reduzir a temperatura em: ", C, " graus celsius.");
    !resfriar(C).

+!verificar_temp(Local, Cultivo): aumentar_temperatura(C, Cultivo) & temp_ideal(Cultivo, Temp_Ideal) <- .print("Temperatura Ideal ", Cultivo, ": ", Temp_Ideal, "°C.");
    .print("Aumentar a temperatura em: ", C, " graus celsius.");
    !aquecer(C).

+!verificar_temp(Local, Cultivo): temperatura_estavel(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Temperatura ideal atingida em: ", C, " graus celsius.").

+!verificar_temp(Local, Cultivo): not temp_atual(Temp_Atual) <- .print("Sem informacao da temperatura atual").

+!aquecer(C): temp_atual(Temp) <- .print("Aquecendo");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp + C);
    .print("Temperatura estabilizada").
    //Aqui havera modificacao do ambiente devido a estabilizacao da temperatura.

+!resfriar(C): temp_atual(Temp) <- .print("Resfriando");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp - C);
    .print("Temperatura estabilizada").
    //Aqui havera modificacao do ambiente devido a estabilizacao da temperatura.

// Planos de Comunicao: 

/* 1. Receber comando do gerenciador */
//Como meu controlador possui na sua base de crencas as informacoes do local e cultivo bem como do cultivo e da temperatura ideal. As unicas informacoes necessarias da mensagem do gerenciador eh temperatura e local

+!comando_gerenciador(Temp_Atual, Local) <-
    .print("Comando recebido do Gerenciador");
    .print("Temperatura: ", Temp_Atual, " graus em Local: ", Local);
    !executar_comando(Temp_Atual, Local).

/* 2. Executar comando recebido */
+!executar_comando(C, Local): not temp_atual(_) <-
    .print("Inicialmente sem informacao de Temperatura");
    +temp_atual(C);
    !regular_temperatura(Local);
    .send(gerenciador_ambiente, tell, status_temperatura(Local, "Estabilizado")).

+!executar_comando(C, Local): temp_atual(TA) & TA \== C <-
    .print("Temperatura medida", C, " Temperatura armazenada", TA);
    -temp_atual(TA);
    +temp_atual(C);
    !regular_temperatura(Local);
    .send(gerenciador_ambiente, tell, status_temperatura(Local, "Estabilizado")).

+!executar_comando(C, Local): temp_atual(TA) & TA == C <-
    .print("Temperatura já estável em ", Local);
    .send(gerenciador_ambiente, tell, temperatura_estavel(Local, Cultivo, C)).

/* 3. Exemplo para enviar status periódico ao gerenciador */
+!reportar_status(Local, Cultivo) : temp_atual(Temp) <-
    .print("Enviando status ao Gerenciador: Temp atual ", Temp);
    .send(gerenciador_ambiente, tell, status_temp(Local, Cultivo, Temp)).

/* 4. Receber pedidos de status */
+?status_temperatura(Local, Cultivo) : true <-
    !reportar_status(Local, Cultivo).