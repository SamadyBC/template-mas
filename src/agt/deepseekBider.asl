/* Beliefs iniciais */


/* Goals iniciais */

/* Plans */

// 1. Primeira oferta ao receber anúncio
// 1. Processamento inicial de tarefas
+tarefa(T, MaxVal) 
  <- .print("Tarefa ", T, " anunciada. Valor máximo: ", MaxVal);
     ?decremento_padrao(D);
     NovaOferta = MaxVal - D;
     .broadcast(tell, oferta(T, NovaOferta));
     // Atualiza o último lance (remove anterior se existir)
     .abolish(ultimo_lance(T, _));
     +ultimo_lance(T, NovaOferta).  // Armazena apenas o lance atual

// 2. Ao ver oferta de concorrente: decide cobrir ou não (respeitando bid_minimo)
+oferta(T, Val)[source(B)] : B \== self & not(vencedor(_,T,_)) 
  <- ?min_total(MinTotal);
     ?soma_atual(Soma);
     ?decremento_padrao(D);
     ?bid_minimo(Min, T);
     if (Soma < MinTotal & Val - D >= Min) {
       NovaOferta = Val - D;
       //.print("Cobrindo oferta de ", B, " em ", T, ": ", NovaOferta);
       .broadcast(tell, oferta(T, NovaOferta));
       // Atualiza último lance
       .abolish(ultimo_lance(T, _));
       +ultimo_lance(T, NovaOferta);
     }.

// 3. Se já houver vencedor: cobre apenas se for vantajoso e dentro do mínimo
+oferta(T, Val)[source(B)] : vencedor(_,T,ValorAtual) & B \== self & Val < ValorAtual
  <- ?min_total(MinTotal);
     ?soma_atual(Soma);
     ?decremento_padrao(D);
     ?bid_minimo(Min, T);
     NovaOferta = Val - D;
     if (NovaOferta >= Min & Soma + NovaOferta >= MinTotal) {
       .broadcast(tell, oferta(T, NovaOferta));
       // Atualiza último lance
       .abolish(ultimo_lance(T, _));
       +ultimo_lance(T, NovaOferta);
     }.