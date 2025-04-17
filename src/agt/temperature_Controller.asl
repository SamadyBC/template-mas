// !regularTemperatura.


+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temperatura(Temp) & Temp < T // plano para tratar objetivo de regular a temperatura
    <- .print("Local:", Local, "Producao: ", X, "Temperatura Ideal:", T, "Temperatura:", Temp);
    .print("Aquecer");
    -temperatura(Temp);
    +temperatura(Temp + 1);
    .wait(1000);
    !regular_temperatura(Local).

+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temperatura(Temp) & Temp > T // plano para tratar objetivo de regular a temperatura
    <- .print("Local:", Local, "Producao: ", X, "Temperatura Ideal:", T);
    .print("Resfriando").

+!regular_temperatura(Local): producao(X, Local) & temp_ideal(X, T) & temperatura(Temp) & Temp == T// plano para tratar objetivo de regular a temperatura
    <- .print("Local:", Local, "Producao: ", X, "Temperatura Ideal:", T).
    

/*+!verificar_temperaturaa(Local)
    <- .send(sensor_temp, askOne, medir_temperatura(Local, Cultivo)).
    .print("Temperatura em ", Local ": ", X)*/