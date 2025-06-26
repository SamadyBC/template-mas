/* Initial beliefs, rules and inferences */

/* Initial goals */

/* Initial plans */
//!verifica_estabilidade().

// Planos de Comunicao:

+!configuracao_inicial <- 
    .print("Configurando o agente Manager");
    joinWorkspace("w1", Wid);
    +workspace("w1", Wid);
    .wait(1000);
    lookupArtifact("tc", Aid);
    focus(Aid);
    !observar_ambiente.

+!observar_ambiente 
    <- .print("Observando o ambiente para verificar a temperatura desejada.");
    !verifica_estabilidade_sistema.

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

+!obtem_temperatura(Local) 
    <- .send(sensor_temp, achieve, obter_temperatura(Local)).

+dados_temperatura(Local, TA): dados_temperatura(_, _)
    <- .print("Recepcao dados do sensor de temperatura");
    !verifica_parametros_temp.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- ?dados_temperatura(Local, TA); // ?dados_temperatura(Local1, TA)[source(sensor_temp)];
    .print("Local: ", Local, " - Temperatura Atual: ", TA," - Cultura: ", Cultura, " - Temperatura Ideal: ", TI);
    if (TI == TA){
        .print("Temperatura estavel");
        -dados_temperatura(Local, TA)[source(sensor_temp)];
    } else{
        .print("Temperatura instavel");
        !ajustar_temperatura(TA, TI);
    }.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- .print("Caso base para debug").

+!ajustar_temperatura(Temp_Atual, Temp_Ideal)
    <- .send(atuador_temp, achieve, ajustar_temperatura(Temp_Atual, Temp_Ideal)).

+status_temp(Estado, Temp): local(Local) & dados_temperatura(Local, TempDtt) 
    <- .print("Local: ", Local, ": ", Estado, " - Temperatura Atual: ", Temp, " - Temperatura anterior: ", TempDtt);
    -dados_temperatura(Local, TempDtt)[source(sensor_temp)];
    -dados_temperatura(Local, Temp)[source(self)];
    +dados_temperatura(Local, Temp);
    -status_temp(Estado, Temp)[source(atuador_temp)];
    -temp_ambiente(TempDtt);
    +temp_ambiente(Temp).

// Planos de Percepcao de Signals:
+setDesiredTemp 
    <- .print("Signal recebido: setDesiredTemp");
    +signal(true);
    ?temperatura_desejada(TempDtt);
    +temp_desejada(TempDtt);
    !verifica_mudanca_temp_ideal.

+!verifica_mudanca_temp_ideal: temp_ideal_cult(Cultivo, TI) & temp_desejada(TD)
    <- .print("Temperatura ideal atualizada: ", TD, " - Temperatura ideal anterior: ", TI);
    if (TI \== TD){
        .print("Houve mudanca na temperatura ideal, reiniciando processo de estabilizacao do sistema");
        -dados_temperatura("Estufa1", TI)[source(sensor_temp)]; // redundante?
        -dados_temperatura("Estufa1", TI); 
        -temp_ideal_cult(Cultivo, TI);
        +temp_ideal_cult(Cultivo, TD);
        -temp_desejada(TI);
        ?producao(Cultivo, Local);
        !obtem_temperatura(Local);
    } else {
        .print("Temperatura ideal nao alterada, mantendo processo de estabilizacao do sistema");
    }.

+verifica_mudanca_temp_ideal 
    <- .print("Teste caso base").