/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */
//!verifica_estabilidade().

// Planos de Comunicao:

+!verifica_estabilidade_sistema: local(Local)
    <- .print("Iniciando objetivo de verificar estabilidade do sistema");
    // Inicialmente busca informacoes do ambiente que esta gerenciando: cultivo, temperaturas ideais cultivo, umidade do solo ideal, quantidade de luz ideal.
    // Inicia o processo verificar os sensores e recolher informacoes atualizadas sobre os parametros de controle - envia dados conforme a necessidade.
    // Realiza esse processo ciclica e reativamente conforme as mensagens dos agentes responsaveis por recolher os dados dos sensores e dos atuadores chegarem.
    // Periodicamente envia dados para o agente orquestrador dos ambientes que eh resposavel por armazenar no banco de dados e gerar relatorios para usuarios.
    !obtem_temperatura(Local).
    //obtem_umidade_solo;
    //obtem_concentracao de CO2
    //obtem_intensidade_luminosa
    //.wait(10000);
    //!verifica_estabilidade_sistema. // Por que exatamente dessa sintaxe?
    /*!ajustar_temperatura(Local);
    .wait(10000);
    !verifica_estabilidade_sistema.
*/
+!obtem_temperatura(Local) 
    <- .send(sensor_temp, achieve, obter_temperatura(Local)).

+dados_temperatura(Local, TA): dados_temperatura(_, _)
    <- .print("Recepcao dados do sensor de temperatura");
    .print("Temperatura em ", Local,": ", TA);
    !verifica_parametros_temp.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- ?dados_temperatura(Local, TA); // Alternativa ?dados_temperatura(Local1, TA)[source(sensor_temp)];
    .print("Local: ", Local);
    .print("Temperatura Atual: ", TA);
    .print("Cultura: ", Cultura);
    .print("Temperatura Ideal: ", TI);
    if (TI == TA){
        .print("Temperatura estavel");
    } else{
        .print("Temperatura instavel");
        !ajustar_temperatura(TA, TI);
    }.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- .print("Caso base para debug").

+!ajustar_temperatura(Temp_Atual, Temp_Ideal)
    <- .send(atuador_temp, achieve, ajustar_temperatura(Temp_Atual, Temp_Ideal)).

+status_temp(Estado, Temp): local(Local) & dados_temperatura(Local, TempDtt) <- .print("Estado da temperatura em ", Local, ": ", Estado, " com temperatura de ", Temp);
    .print("Temperatura anterior: ", TempDtt);
    -dados_temperatura(Local, TempDtt)[source(sensor_temp)];
    +dados_temperatura(Local, Temp);
    +temp_ambiente(Temp).