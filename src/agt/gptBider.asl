// samadyBider.asl

// Reage ao anúncio de tarefa
+tarefa(T, MaxVal): decremento(D,T)
    <- PrimeiraOferta = MaxVal - D;
       //.print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
       //.print("Vou iniciar oferta para ", T, " em ", PrimeiraOferta, " (decremento de ", D, ")");
       .broadcast(tell, oferta(T, PrimeiraOferta));
       +meu_lance(T, PrimeiraOferta);
       !atualiza_soma;
       -decremento(D,T);          // remove o decremento inicial (poderia ser opcional)
       +decremento(3000,T).       // passa a usar decremento de 1000

// Reage apenas a ofertas melhores (menores que a minha)
+oferta(T, Val)[source(Bider)]: meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D >= Min)
    <- NovaOferta = Val - D;
       //.print("Concorrente ofertou ", Val, " MENOR que o meu lance (", MeuUltimo, ") na tarefa ", T, ". Cobrindo com ", NovaOferta);
       !registrar_menor_oferta(Bider, T, Val);
       !incrementa_agressividade(T);
       !ajusta_decremento(T);
       !verifica_soma_total(T, NovaOferta).
       //.wait(200).


+oferta(T, Val): meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D < Min) // Ao inves de sair da disputa unicamente, verificar margem e realizar lance limite baseado na margem 
    <- !registrar_menor_oferta(Bider, T, Val);
    //.print("Verificando a possibilidade de adaptar meu bid minimo para ", T);
    !incrementa_agressividade(T);
    !ajusta_decremento(T);
    !ajustar_bid_minimo(T). 
    //.print("Vou ficar de fora da tarefa ", T, " pois o valor já está em ", Val, " e meu mínimo é ", Min, ".").

// Primeiro registro de oferta para esse agente-tarefa
+!registrar_menor_oferta(Bider, T, Val) : not menor_oferta(Bider, T, _)
    <- +menor_oferta(Bider, T, Val);
       //.print("Registrei primeira oferta de ", Bider, " para ", T, ": ", Val);
       !verifica_concorrentes_20k(Bider).

// Atualiza oferta se for menor que a anterior
+!registrar_menor_oferta(Bider, T, Val) : menor_oferta(Bider, T, VOld) & (Val < VOld)
    <- -menor_oferta(Bider, T, VOld);
       +menor_oferta(Bider, T, Val);
       //.print("Atualizei menor oferta de ", Bider, " para ", T, ": ", Val);
       !verifica_concorrentes_20k(Bider).

/* Ignora ofertas não menores - Esse codigo pode ser removido */
+!registrar_menor_oferta(Bider, T, Val) : menor_oferta(Bider, T, VOld) & (Val >= VOld)
    <- .print("Oferta de ", Bider, " para ", T, " (", Val, ") NÃO é menor que seu menor registro (", VOld, ")").

+!verifica_concorrentes_20k(Bider)
  <- .findall(Val, menor_oferta(Bider, _, Val), Lances);
     !soma_lista(Lances, Soma);
     !verifica_soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : soma_bider(Bider, S) & Soma >= 20000
  <- //.print("Teste ", Bider, ": ", Soma);
     //.print("O concorrente ", Bider, " já ofertou 20k ou mais nas três tarefas!");
     -soma_bider(Bider, _);
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : not soma_bider(Bider, S) & Soma >= 20000
  <- //.print("Primeira Execucao", Bider, ": ", Soma);
     //.print("O concorrente ", Bider, " já ofertou 20k ou mais nas três tarefas!");
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : soma_bider(Bider, S) & Soma < 20000
  <- //.print("Teste ", Bider, ": ", Soma);
     //.print("O concorrente ", Bider, " ofertou menos que 20k nas três tarefas.");
     -soma_bider(Bider, _);
     +soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : not soma_bider(Bider, S) & Soma < 20000
  <- //.print("Primeira Execucao", Bider, ": ", Soma);
     //.print("O concorrente ", Bider, " ofertou menos que 20k nas três tarefas.").
     +soma_bider(Bider, Soma).

+!incrementa_agressividade(T)
  : agressividade_concorrencia(T, N)
  <- N1 = N + 1;
     -agressividade_concorrencia(T, _);
     +agressividade_concorrencia(T, N1).

+!incrementa_agressividade(T)
  : not agressividade_concorrencia(T, _)
  <- +agressividade_concorrencia(T, 1).

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N >= 3
  <- -decremento(_, T);
     +decremento(500, T).

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N == 2
  <- -decremento(_, T);
     +decremento(1000, T).

+!ajusta_decremento(T) : agressividade_concorrencia(T, N) & N <= 1
  <- -decremento(_, T);
     +decremento(2000, T).

+!atualiza_soma
   <- .findall(V, meu_lance(_, V), L);
      !soma_lista(L, S);
      -soma_atual(_);
      +soma_atual(S).
      //.print("Soma atualizada: ", S).

// Caso em que compensa ajustar
+!ajustar_bid_minimo(T) : soma_atual(S) & min_total(Min) & decremento(D, T) & menor_oferta(Outro, T, Val) & meu_lance(T, MeuLance) & S > Min & ( MeuLance - Val <= (S - (Min + D)))
   <- Novo_Lance = Val - D;
   -bid_minimo(_, T);
   +bid_minimo(Novo_Lance, T);
   //.print("Decremento: ", D);
   //.print("Soma atual: ", S);
   //.print("Ajustei o bid_minimo da tarefa ", T, " para: ", Novo_Lance, " visando atingir a meta exata!");
   //!lance_final(T).
   !verifica_soma_total(T, Novo_Lance).

// Caso em que não compensa ajustar
+!ajustar_bid_minimo(T) : soma_atual(S) & min_total(Min) & decremento(D, T) & menor_oferta(Outro, T, Val) & meu_lance(T, MeuLance) & S < Min 
   <- true. //.print("NÃO ajustei o bid_minimo de ", T, ". Oferta não permite bater a meta precisa.").

+!ajustar_bid_minimo(T) : soma_atual(S) & min_total(Min) & decremento(D, T) & menor_oferta(Outro, T, Val) & meu_lance(T, MeuLance) 
   <- true.
   // .print("Soma: ", S);
   // .print("Minimo total ", Min);
   // .print("Decremento ", D);
   // .print("Menor oferta adversaria ", Val);
   // .print("Meu lance ", MeuLance).

+!ajustar_bid_minimo(T) <- true. //.print("Caso padrao").

+!lance_final(T) : bid_minimo(Min, T)
  <- //.print("Enviando lance final de ", Min, " na tarefa ", T, " para tentar fechar a meta!");
     .broadcast(tell, oferta(T, Min));
     -meu_lance(T, _);
     +meu_lance(T, Min).
     

/* Dispara o controle assim que soma_atual mudar
+soma_atual(S) : min_total(Min) & S >= Min
   <- .print("A soma dos lances realizados é (", S, ") esta acima da cota mínima (", Min, ")").

+soma_atual(S) : min_total(Min) & S < Min
   <- .print("A soma dos lances realizados é ", S, ". esta abaixo da cota mínima (", Min, ")").
*/

+!verifica_soma_total(T, Oferta): soma_atual(S) & min_total(MinTotal) & S - Oferta > MinTotal 
   <- .broadcast(tell, oferta(T, Oferta)); // Novo plano a partir do verifica soma.
   -meu_lance(T, _); // remove lance anterior // Novo plano a partir do verifica soma.
   +meu_lance(T, Oferta); // Novo plano a partir do verifica soma.
   !atualiza_soma. // Novo plano a partir do verifica soma.

+!verifica_soma_total(T, Oferta): soma_atual(S) & min_total(MinTotal) & S - Oferta <= MinTotal <- true.

+!verifica_soma_total(T, Oferta) <- true.

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
