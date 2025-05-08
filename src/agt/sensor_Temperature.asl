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

+!comando_gerenciador(Local) <- // Implementar: caso de uso - primeiro comando enviado e demais comandos enviados
    .print("Comando recebido do Gerenciador");
    .print("Verficar temperatura em: ", Local);
    !executar_comando(Local).

// Planos de Comunicao:
+!executar_comando(Local): temp_ambiente(TA) // Como retornar esse dado depois dechamar o plano medir temperatura?
    <- !medir_temperatura;
    //.print("Temperatura ", TA, " graus ", "em ", Local);
    .send(gerenciador_ambiente, tell, dados_temperatura(Local, TA)).