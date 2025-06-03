/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */

+!configuracao_inicial <- 
    .print("Configurando o agente Sensor de Temperatura");
    joinWorkspace("w1", Wid);
    +workspace("w1", Wid);
    .wait(1000);
    lookupArtifact("tc", Aid);
    focus(Aid);
    !observar_ambiente.

+!observar_ambiente <- // Melhorar implementacao aplicando periodicidade e contextos diferentes para a execucao desse plano.
    .print("Observando o ambiente para verificar a temperatura atual.").

+!medir_temperatura: temp_ambiente(TA) // Este objetivo estara conectado ao ambiente - uma janela onde sera possivel alterar o valor da temperatura. Realizar leitura do ambiente
    <- .print("Temperatura Medida: ", TA).
    //.wait(10000);
    //!medir_temperatura.

+!medir_temperatura: not temp_ambiente(_) // Este objetivo estara conectado ao ambiente - uma janela onde sera possivel alterar o valor da temperatura. Realizar leitura do ambiente
    <- TA = 33; 
    +temp_ambiente(TA);
    .print("Temperatura Medida Primeira Vez: ", TA).
    //.wait(5000);
    //!medir_temperatura.

+!obter_dados_sensorTemp: not temperatura_ambiente(_)
    <- .print("Primeira leitura - ainda sem dados do sensor de temperatura");
    .wait(500);
    !obter_dados_sensorTemp.

+!obter_dados_sensorTemp: temperatura_ambiente(TA)
    <- .print("Leitura sensor de temperatura: ", TA);
    +temp_ambiente_medida(TA);
    +temp_ambiente(TA);
    .print("Temperatura Medida Sensor: ", TA).

+!obter_temperatura(Local): temp_ambiente(_) // Implementar: caso de uso - primeiro comando enviado e demais comandos enviados
    <- .print("Comando recebido do Gerenciador");
    .print("Verficar temperatura em: ", Local);
    !executar_comando(Local).

+!obter_temperatura(Local): not temp_ambiente(_) <- // Implementar: caso de uso - primeiro comando enviado e demais comandos enviados
    .print("Primeiro comando recebido do Gerenciador");
    .print("Verficar temperatura em: ", Local);
    !executar_comando(Local).

// Planos de Comunicao:
+!executar_comando(Local): temp_ambiente(TA) // Como retornar esse dado depois de chamar o plano medir temperatura?
    <- //!medir_temperatura;
    !obter_dados_sensorTemp;
    //.print("Temperatura ", TA, " graus ", "em ", Local);
    .send(gerenciador_ambiente, tell, dados_temperatura(Local, TA)).

+!executar_comando(Local): not temp_ambiente(TA) // Como retornar esse dado depois dechamar o plano medir temperatura? - modificar essa crenca, adaptar o contexto
    <- //!medir_temperatura;
    !obter_dados_sensorTemp;
    ?temp_ambiente(Temp_Amb_Medida);
    ?temp_ambiente_medida(Temp_Amb_Medida2);
    .print("EC - Temperatura Medida: ", Temp_Amb_Medida);
    .send(gerenciador_ambiente, tell, dados_temperatura(Local, Temp_Amb_Medida)).
