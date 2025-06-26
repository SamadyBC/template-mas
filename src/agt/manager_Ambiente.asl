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

+!observar_ambiente // Melhorar implementacao aplicando periodicidade e contextos diferentes para a execucao desse plano.
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
    !verifica_parametros_temp.

+!verifica_parametros_temp: producao(Cultura, Local) & temp_ideal_cult(Cultura, TI)
    <- ?dados_temperatura(Local, TA); // Alternativa ?dados_temperatura(Local1, TA)[source(sensor_temp)];
    .print("Local: ", Local, " - Temperatura Atual: ", TA," - Cultura: ", Cultura, " - Temperatura Ideal: ", TI);
    if (TI == TA){
        .print("Temperatura estavel");
        //-dados_temperatura(Local, TA)[source(sensor_temp)]; // Sera necessario remover essa crenca?
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
    +dados_temperatura(Local, Temp);
    -status_temp(Estado, Temp)[source(atuador_temp)];
    +temp_ambiente(Temp).

//Verfica que houve uma alteracao na temperatura deseja e entao atualiza sua base de crencas, bem como reinicia o processo de estabilizacao do sistema.

// Planos de Percepcao de Signals:
+setDesiredTemp 
    <- .print("Signal recebido: setDesiredTemp");
    +signal(true);
    ?temperatura_desejada(TempDtt);
    .print("Nova temperatura desejada: ", TempDtt);
    +temp_desejada(TempDtt);
    !verifica_mudanca_temp_ideal.

+!verifica_mudanca_temp_ideal: temp_ideal_cult(Cultivo, TI) & temp_desejada(TD)
    <- .print("Verificando se houve mudanca na temperatura ideal", TI, " e temperatura desejada ", TD);
    if (TI \== TD){
        .print("Houve mudanca na temperatura ideal, reiniciando processo de estabilizacao do sistema");
        -dados_temperatura("Estufa1", TI)[source(sensor_temp)];
        -temp_ideal_cult(Cultivo, TI);
        +temp_ideal_cult(Cultivo, TD);
        !verifica_estabilidade_sistema;
    } else {
        .print("Temperatura ideal nao alterada, mantendo processo de estabilizacao do sistema");
    }.

+verifica_mudanca_temp_ideal 
    <- .print("Teste caso base").