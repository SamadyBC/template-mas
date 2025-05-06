// gptBider.asl (NÃO repita as crenças iniciais aqui)

// Reage ao anúncio de tarefa
+tarefa(T, MaxVal): decremento(D,T)
    <- PrimeiraOferta = MaxVal - D;
       .print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
       .print("Vou iniciar oferta para ", T, " em ", PrimeiraOferta, " (decremento de ", D, ")");
       .broadcast(tell, oferta(T, PrimeiraOferta));
       +meu_lance(T, PrimeiraOferta);
       !atualiza_soma;
       -decremento(D,T);          // remove o decremento inicial (poderia ser opcional)
       +decremento(3000,T).       // passa a usar decremento de 1000

// Reage apenas a ofertas melhores (menores que a minha)
+oferta(T, Val)[source(Bider)]: meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D >= Min)
    <- NovaOferta = Val - D;
       .print("Concorrente ofertou ", Val, " MENOR que o meu lance (", MeuUltimo, ") na tarefa ", T, ". Cobrindo com ", NovaOferta);
       !registrar_menor_oferta(Bider, T, Val);
       !incrementa_agressividade(T);
       !ajusta_decremento(T);
       .wait(200);
       .broadcast(tell, oferta(T, NovaOferta));
       -meu_lance(T, _); // remove lance anterior
       +meu_lance(T, NovaOferta);
       !atualiza_soma.


+oferta(T, Val): meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D < Min) // Ao inves de sair da disputa unicamente, verificar margem e realizar lance limite baseado na margem 
    <- !registrar_menor_oferta(Bider, T, Val);  
    .print("Vou ficar de fora da tarefa ", T, " pois o valor já está em ", Val, " e meu mínimo é ", Min, ".").

// Primeiro registro de oferta para esse agente-tarefa
+!registrar_menor_oferta(Bider, T, Val) : not menor_oferta(Bider, T, _)
    <- +menor_oferta(Bider, T, Val);
       .print("Registrei primeira oferta de ", Bider, " para ", T, ": ", Val);
       !verifica_concorrentes_20k(Bider).

// Atualiza oferta se for menor que a anterior
+!registrar_menor_oferta(Bider, T, Val) : menor_oferta(Bider, T, VOld) & (Val < VOld)
    <- -menor_oferta(Bider, T, VOld);
       +menor_oferta(Bider, T, Val);
       .print("Atualizei menor oferta de ", Bider, " para ", T, ": ", Val);
       !verifica_concorrentes_20k(Bider).

// Ignora ofertas não menores - Esse codigo pode ser removido
+!registrar_menor_oferta(Bider, T, Val) : menor_oferta(Bider, T, VOld) & (Val >= VOld)
    <- .print("Oferta de ", Bider, " para ", T, " (", Val, ") NÃO é menor que seu menor registro (", VOld, ")").

+!verifica_concorrentes_20k(Bider)
  <- .findall(Val, menor_oferta(Bider, _, Val), Lances);
     !soma_lista(Lances, Soma);
     !verifica_soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : soma_bider(Bider, S) & Soma >= 20000
  <- .print("Teste ", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " já ofertou 20k ou mais nas três tarefas!");
     -soma_bider(Bider, _);
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : not soma_bider(Bider, S) & Soma >= 20000
  <- .print("Primeira Execucao", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " já ofertou 20k ou mais nas três tarefas!");
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : soma_bider(Bider, S) & Soma < 20000
  <- .print("Teste ", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " ofertou menos que 20k nas três tarefas.");
     -soma_bider(Bider, _);
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : not soma_bider(Bider, S) & Soma < 20000
  <- .print("Primeira Execucao", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " ofertou menos que 20k nas três tarefas.").
     +soma_bider(Bider, Soma).

+!incrementa_agressividade(T)
  : agressividade_concorrencia(T, N)
  <- N1 = N + 1;
     -agressividade_concorrencia(T, N);
     +agressividade_concorrencia(T, N1).

+!incrementa_agressividade(T)
  : not agressividade_concorrencia(T, _)
  <- +agressividade_concorrencia(T, 1).

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N >= 3
  <- -decremento(_, T);
     +decremento(500, T);
     .print("Ajustei decremento da tarefa ", T, " para 500 (agressividade alta, ", N, " concorrentes)").

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N == 2
  <- -decremento(_, T);
     +decremento(1000, T);
     .print("Ajustei decremento da tarefa ", T, " para 1000 (agressividade média, ", N, " concorrentes)").

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N <= 1
  <- -decremento(_, T);
     +decremento(2000, T);
     .print("Ajustei decremento da tarefa ", T, " para 2000 (agressividade baixa, ", N, " concorrente)").

+!atualiza_soma
   <- .findall(V, meu_lance(_, V), L);
      !soma_lista(L, S);
      -soma_atual(_);
      +soma_atual(S).

// Dispara o controle assim que soma_atual mudar
+soma_atual(S) : min_total(Min) & S >= Min
   <- .print("A soma dos lances realizados é (", S, ") esta acima da cota mínima (", Min, ")").

+soma_atual(S) : min_total(Min) & S < Min
   <- .print("A soma dos lances realizados é ", S, ". esta abaixo da cota mínima (", Min, ")").


// Caso base: lista vazia
+!soma_lista([], 0).

// Caso geral: lista não-vazia
+!soma_lista([H|T], Soma)
  <- !soma_lista(T, SomaT);
     Soma = H + SomaT.

// Checagem final de soma
+!checar_soma_final
    <- ?soma_atual(S);
       ?min_total(MinReq);
       .print("Total ganho: ", S);
       .print("Meta mínima: ", MinReq).




/*
To do:
Verificar menores valores ofertados em cada tarefa e adicionar a base de crencas - DONE
Verificar o valor ofertado por cada um dos agentes em cada uma das suas tarefas e somar para tomar decisoes - DONE - baseado na soma decidir encerrar os meus lances
Quando o valor esta abaixo do meu minimo realizar a ultima oferta sendo o valor minimo previsto - 
Verificar calculos para determinar qual o valor que deve ser oferecido para cumprir os requisitos. - Isso deve levar em consideracao a agressividade dos concorrentes.
Determinar decrescimo de maneira dinamica atraves de calculos - DONE
*/