+!medir_temperatura
    <- .print("Temperatura Medida: ", 25).


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