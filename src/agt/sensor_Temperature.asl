/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */
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
    <- !medir_temperatura;
    //.print("Temperatura ", TA, " graus ", "em ", Local);
    .send(gerenciador_ambiente, tell, dados_temperatura(Local, TA)).

+!executar_comando(Local): not temp_ambiente(TA) // Como retornar esse dado depois dechamar o plano medir temperatura?
    <- !medir_temperatura;
    ?temp_ambiente(Temp_Amb_Medida);
    .print("EC - Temperatura Medida: ", Temp_Amb_Medida).
    .send(gerenciador_ambiente, tell, dados_temperatura(Local, Temp_Amb_Medida)).