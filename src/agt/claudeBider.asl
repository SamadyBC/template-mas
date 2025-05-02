/* Initial beliefs and rules */
// Valor mínimo total que precisa ser obtido
min_total(20000).

// Valor mínimo aceitável para cada tarefa
valor_minimo(5000).

// Decremento padrão para cobrir ofertas
decremento_padrao(1000).

// Decremento agressivo para tarefas prioritárias
decremento_agressivo(2000).

// Lista de tarefas que o agente está participando
// tarefa_ativa(ID, ValorAtual, Prioridade)
// Prioridade: 1 (alta) a 3 (baixa)

// Soma das tarefas que o agente está vencendo atualmente
soma_atual(0).

// Calcula a soma de valores em uma lista
soma_lista([], 0).
soma_lista([V|Resto], Total) :-
    soma_lista(Resto, SubTotal) &
    Total = V + SubTotal.

// Calcula se pode fazer uma oferta para uma tarefa
pode_ofertar(T, NovoValor) :-
    soma_atual(SomaAtual) &
    vencendo(ListaTarefas) &
    .length(ListaTarefas, N) &
    (N > 0 | NovoValor >= 20000).

// Lista de tarefas que o agente está vencendo
vencendo(L) :- .findall(tarefa(T,V), vencendo_tarefa(T,V), L).

/* Plans */
// Quando recebe anúncio de tarefa
+tarefa(T, MaxVal) <-
    .print("Recebi anúncio da tarefa ", T, " com valor máximo de ", MaxVal);
    // Adiciona a tarefa como ativa com prioridade média (2)
    +tarefa_ativa(T, MaxVal, 2);
    // Faz oferta inicial com 20% abaixo do valor máximo
    .random(R);
    ValorInicial = MaxVal - (0.2 + (R * 0.1)) * MaxVal;
    .print("Fazendo oferta inicial para tarefa ", T, " de ", ValorInicial);
    .broadcast(tell, oferta(T, ValorInicial)).

// Quando o agente vence uma tarefa (recebe confirmação do leiloeiro)
+vencedor(Ag, T, Val)[source(leiloeiro)] : .my_name(Ag) <-
    .print("Estou vencendo a tarefa ", T, " com valor ", Val);
    -+vencendo_tarefa(T, Val);
    // Atualiza a soma atual
    .findall(V, vencendo_tarefa(_, V), Valores);
    // Calcula a soma usando nossa regra
    ?soma_lista(Valores, NovaSOma);
    -+soma_atual(NovaSOma);
    .print("Soma atual de tarefas vencendo: ", NovaSOma).

// Quando o agente perde uma tarefa que estava vencendo
+vencedor(Ag, T, Val)[source(leiloeiro)] : vencendo_tarefa(T, _) & not .my_name(Ag) <-
    .print("Perdi a tarefa ", T, " para ", Ag, " com valor ", Val);
    -vencendo_tarefa(T, _);
    // Atualiza a soma atual
    .findall(V, vencendo_tarefa(_, V), Valores);
    // Calcula a soma usando nossa regra
    ?soma_lista(Valores, NovaSOma);
    -+soma_atual(NovaSOma);
    .print("Soma atual de tarefas vencendo: ", NovaSOma);
    // Aumenta a prioridade desta tarefa
    ?tarefa_ativa(T, _, P);
    NovaPrioridade = math.max(1, P-1);
    -+tarefa_ativa(T, Val, NovaPrioridade);
    .print("Aumentando prioridade da tarefa ", T, " para ", NovaPrioridade).

// Quando recebe uma oferta de outro agente para uma tarefa que está participando
+oferta(T, Val)[source(Ag)] : 
    tarefa_ativa(T, _, P) & 
    not .my_name(Ag) &
    valor_minimo(MinVal) & 
    Val > MinVal <-
    
    // Decide o decremento baseado na prioridade
    if (P == 1) {
        ?decremento_agressivo(D);
    } else {
        ?decremento_padrao(D);
    }
    
    // Calcula nova oferta
    NovoValor = Val - D;
    
    // Verifica se pode fazer a oferta considerando o total mínimo
    ?soma_atual(SomaAtual);
    .findall(tarefa(Tid,Tval), vencendo_tarefa(Tid,Tval), ListaVencendo);
    
    if (NovoValor >= MinVal & pode_ofertar(T, NovoValor)) {
        .print("Cobrindo oferta para tarefa ", T, " de ", Val, " com ", NovoValor);
        .wait(math.random(300) + 100); // Espera aleatória para evitar conflitos
        .broadcast(tell, oferta(T, NovoValor));
    } else {
        .print("Não vou cobrir oferta para tarefa ", T, " pois valor ", NovoValor, 
               " é muito baixo ou comprometeria o mínimo total de 20k");
    }.

// Avaliação periódica usando um evento de tempo
+!start <-
    .print("Agente licitante estratégico iniciado!");
    .at("now +1000", "+verificar_estrategia").

+verificar_estrategia <-
    //.print("Avaliando estratégia atual...");
    ?soma_atual(Soma);
    //.print("Soma atual de tarefas vencendo: ", Soma);
    
    if (Soma < 20000) {
        .print("Alerta: Soma atual abaixo do mínimo necessário!");
        // Busca tarefas ativas que não estamos vencendo
        .findall(tarefa(T,V,P), tarefa_ativa(T,V,P) & not vencendo_tarefa(T,_), TarefasDisponiveis);
        
        if (.length(TarefasDisponiveis) > 0) {
            .print("Tarefas disponíveis para tentar: ", TarefasDisponiveis);
            // Aumenta prioridade de todas as tarefas disponíveis
            for (.member(tarefa(T,V,P), TarefasDisponiveis)) {
                -+tarefa_ativa(T, V, 1);
                .print("Aumentando prioridade da tarefa ", T, " para máxima");
            }
        }
    }
    
    // Agenda a próxima verificação
    .at("now +5000", "+verificar_estrategia").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }