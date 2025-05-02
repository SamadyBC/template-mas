/* Beliefs iniciais */


/* Goals iniciais */

/* Plans */

// 1. Primeira oferta ao receber anúncio
// 1. Processamento inicial de tarefas
+tarefa(T, MaxVal) 
  <- .print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
    ?decremento_padrao(D);
    PrimeiraOferta = MaxVal - D;
    .print("Vou iniciar oferta para ", T, " em ", PrimeiraOferta, " (decremento de ", D, ")");
    .broadcast(tell, oferta(T, PrimeiraOferta)).

// 2. Tratamento de ofertas concorrentes
+oferta(T, Val)[source(B)] : B \== self
  <- ?min_total(MinTotal);
     ?soma_atual(Soma);
     ?decremento_padrao(D);
     .print("Analisando oferta de ", B, " (", Val, ") para ", T);
     if (Soma < MinTotal) {
       NovaOferta = Val - D;
       .print("Vou cobrir a oferta de ", Val, " com ", Val-D, " para a tarefa ", T);
       .wait(200);
       .broadcast(tell, oferta(T, NovaOferta));
     }.

// 3. Atualização de ofertas quando há vencedor
+oferta(T, Val)[source(B)] : vencedor(_,T,ValorAtual) & B \== self & Val < ValorAtual
  <- ?min_total(MinTotal);
     ?soma_atual(Soma);
     ?decremento_padrao(D);
     NovaOferta = Val - D;
     if (Soma + NovaOferta >= MinTotal) {
       .broadcast(tell, oferta(T, NovaOferta));
     }.

// 4. Atualização ao vencer
+vencedor(self, T, Val)
  <- .print("Ganhei ", T, " por ", Val);
     ?soma_atual(Soma);
     NovaSoma = Soma + Val;
     .abolish(soma_atual(_));
     +soma_atual(NovaSoma);
     if (NovaSoma >= 20000) {
       .print("Meta de 20k atingida");
       .drop_desire(monitorar_ofertas);  // Corrigido: substitui .abolish(!...)
     }.