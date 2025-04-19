/* Initial beliefs, rules and inferences */

reduzir_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual > Temp_Ideal & C = Temp_Atual - Temp_Ideal.
aumentar_temperatura (C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual < Temp_Ideal & C = Temp_Ideal - Temp_Atual.
temperatura_estavel(C, X) :- temp_atual(Temp_Atual) & temp_ideal(X, Temp_Ideal) & Temp_Atual == Temp_Ideal & C = Temp_Ideal.

/* Initial goals */
// !regularTemperatura. Como esse objetivo eh adicionado na declaracao do agente, entao nao ha necessidade de adicionar aqui

/* Initial plans */

+!verificar_temp(Local, Cultivo): reduzir_temperatura(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Reduzir a temperatura em: ", C, " graus celsius.");
    !resfriar(C).

+!verificar_temp(Local, Cultivo): aumentar_temperatura(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Aumentar a temperatura em: ", C, " graus celsius.");
    !aquecer(C).

+!verificar_temp(Local, Cultivo): temperatura_estavel(C, Cultivo) <- .print("Cultivo: ", Cultivo);
    .print("Temperatura ideal atingida em: ", C, " graus celsius.").

+!regular_temperatura(Local): producao(Cultivo, Local) <- !verificar_temp(Local, Cultivo);
    .print("Local: ", Local, " - Producao: ", Cultivo);
    .wait(5000);
    !regular_temperatura(Local).

+!aquecer(C): temp_atual(Temp) <- .print("Aquecendo");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp + C).

+!resfriar(C): temp_atual(Temp) <- .print("Resfriando");
    .wait(1500);
    -temp_atual(Temp);
    +temp_atual(Temp - C).

/*
+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temp_atual(Temp) & Temp < T // plano para tratar objetivo de regular a temperatura
    <- .print("Local: ", Local, "Producao: ", X, "Temperatura Ideal: ", T, "Temperatura ambiente: ", Temp);
    .print("Aquecer");
    -temp_atual(Temp);
    +temp_atual(Temp + 1);
    .wait(1500);
    !regular_temperatura(Local).

+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temp_atual(Temp) & Temp > T // plano para tratar objetivo de regular a temperatura
    <- .print("Local:", Local, "Producao: ", X, "Temperatura Ideal:", T);
    .print("Resfriando").

+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temp_atual(Temp) & Temp == T// plano para tratar objetivo de regular a temperatura
    <- .print("Temperatura ideal atingida");
    .print("Local:", Local, "Producao: ", X, "Temperatura Ideal:", T).
    

+!verificar_temperaturaa(Local)
    <- .send(sensor_temp, askOne, medir_temperatura(Local, Cultivo)).
    .print("Temperatura em ", Local ": ", X) */