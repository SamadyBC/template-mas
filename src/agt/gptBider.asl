// gptBider.asl (NÃO repita as crenças iniciais aqui)

// Reage ao anúncio de tarefa
+tarefa(T, MaxVal): decremento(D,T)
    <- PrimeiraOferta = MaxVal - D;
       .print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
       .print("Vou iniciar oferta para ", T, " em ", PrimeiraOferta, " (decremento de ", D, ")");
       .broadcast(tell, oferta(T, PrimeiraOferta));
       +meu_lance(T, PrimeiraOferta);
       -decremento(D,T);          // remove o decremento inicial (poderia ser opcional)
       +decremento(1000,T).       // passa a usar decremento de 1000

// Reage apenas a ofertas melhores (menores que a minha)
+oferta(T, Val)[source(Bider)]: meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D >= Min)
    <- NovaOferta = Val - D;
       .print("Concorrente ofertou ", Val, " MENOR que o meu lance (", MeuUltimo, ") na tarefa ", T, ". Cobrindo com ", NovaOferta);
       !registrar_menor_oferta(Bider, T, Val);
       .wait(200);
       .broadcast(tell, oferta(T, NovaOferta));
       -meu_lance(T, _); // remove lance anterior
       +meu_lance(T, NovaOferta).

+oferta(T, Val): meu_lance(T, MeuUltimo) & bid_minimo(Min, T) & decremento(D, T) & (Val < MeuUltimo) & (Val - D < Min)
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

// Ignora ofertas não menores
+!registrar_menor_oferta(Bider, T, Val) : menor_oferta(Bider, T, VOld) & (Val >= VOld)
    <- .print("Oferta de ", Bider, " para ", T, " (", Val, ") NÃO é menor que seu menor registro (", VOld, ")").

+!verifica_concorrentes_20k(Bider)
  <- .findall(Val, menor_oferta(Bider, _, Val), Lances);
     !soma_lista(Lances, Soma);
     !verifica_soma_bider(Bider, Soma).

+!verifica_soma_bider(Bider, Soma) : Soma >= 20000
  <- .print("Total ofertado por ", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " já ofertou 20k ou mais nas três tarefas!").

+!verifica_soma_bider(Bider, Soma) : Soma < 20000
  <- .print("Total ofertado por ", Bider, ": ", Soma);
     .print("O concorrente ", Bider, " ofertou menos que 20k nas três tarefas.").

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
Verificar o valor ofertado por cada um dos agentes em cada uma das suas tarefas e somar para tomar decisoes - DONE 
Quando o valor esta abaixo do meu minimo realizar a ultima oferta sendo o valor minimo previsto - 
Verificar calculos para determinar qual o valor que deve ser oferecido para cumprir os requisitos. -
Determinar decrescimo de maneira dinamica atraves de calculos - 
*/