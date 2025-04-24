/* Initial beliefs, rules and inferences */
// Alterar variaveis: C -> Graus, X -> Cultivo
reduzir_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual > Temp_Ideal & C = Temp_Atual - Temp_Ideal.
aumentar_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual < Temp_Ideal & C = Temp_Ideal - Temp_Atual.
temperatura_estavel(C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual == Temp_Ideal & C = Temp_Ideal.

/* Initial goals */
// !regularTemperatura. Como esse objetivo eh adicionado na declaracao do agente, entao nao ha necessidade de adicionar aqui

/* Initial plans */

+!regular_temperatura(Local): producao(Cultivo, Local) <- !verificar_temp(Local, Cultivo);
    .print("Local: ", Local, " - Producao: ", Cultivo);
    .wait(5000);
    !regular_temperatura(Local).

+!verificar_temp(Local, Cultivo): reduzir_temperatura(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Reduzir a temperatura em: ", C, " graus celsius.");
    !resfriar(C).

+!verificar_temp(Local, Cultivo): aumentar_temperatura(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Aumentar a temperatura em: ", C, " graus celsius.");
    !aquecer(C).

+!verificar_temp(Local, Cultivo): temperatura_estavel(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Temperatura ideal atingida em: ", C, " graus celsius.").

+!aquecer(C): temp_atual(Temp) <- .print("Aquecendo");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp + C).

+!resfriar(C): temp_atual(Temp) <- .print("Resfriando");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp - C).