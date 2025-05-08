/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */
//!verifica_estabilidade().

// Planos de Comunicao:

+!verifica_estabilidade_sistema 
    <- .print("Sou o agente gerenciador");
    Local = "Estufa1";
    !obtem_temperatura(Local);
    .wait(500);
    !ajustar_temperatura(Local);
    .wait(10000);
    !verifica_estabilidade_sistema.

+!obtem_temperatura(Local) 
    <- .send(sensor_temp, achieve, comando_gerenciador(Local)).

+!ajustar_temperatura(Local): dados_temperatura(Local, TA)
    <- .send(atuador_temp, achieve, comando_gerenciador(TA, Local)).

+!ajustar_temperatura(Local): not dados_temperatura(Local, TA)
    <- .print("Sem dados de temperatura").




//.send(sensor_temp, tell, comando_gerenciador(Local)).