/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */
//!verifica_estabilidade().

// Planos de Comunicao:

+!verifica_estabilidade_sistema: local(Local)
    <- .print("Iniciando objetivo de verificar estabilidade do sistema");
    // Local = "Estufa1"; // Deixar isso dinamico
    !obtem_temperatura(Local);
    .wait(10000);
    !verifica_estabilidade_sistema.
    /*!ajustar_temperatura(Local);
    .wait(10000);
    !verifica_estabilidade_sistema.
*/
+!obtem_temperatura(Local) 
    <- .send(sensor_temp, achieve, obter_temperatura(Local)).

+dados_temperatura(Local, TA): not dados_temperatura(_, _)
    <- .print("Primeira recepcao de dados");
    .print("Temperatura em ", Local,": ", TA);
    !verifica_parametros_temp.

+dados_temperatura(Local, TA): dados_temperatura(Local, TA)
    <- .print("Demais recepcoes de dados");
    .print("Temperatura em ", Local,": ", TA);
    !verifica_parametros_temp.

+!verifica_parametros_temp: dados_temperatura(Local, TA) & producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- .print("Local: ", Local);
    .print("Temperatura Atual: ", TA);
    .print("Cultura: ", Cultura);
    .print("Temperatura Ideal: ", TI);
    if (TI == TA){
        .print("Temperatura estavel");
    } else{
        .print("Temperatua instavel");
        !ajustar_temperatura(TA, TI);
    }.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- .print("Caso base para debug").

+!ajustar_temperatura(Temp_Atual, Temp_Ideal)
    <- .send(atuador_temp, achieve, ajustar_temperatura(Temp_Atual, Temp_Ideal)).
/*
+!ajustar_temperatura(Local): not dados_temperatura(Local, TA)
    <- .print("Sem dados de temperatura").
*/
//Alterar comportamento do agente de gerenciamento de temperatura para que ele realize o ajuste da temperatura quando receber os dados de temperatura.
//Adicionar comportamento ciclico.


//.send(sensor_temp, tell, comando_gerenciador(Local)).