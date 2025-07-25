
cortina_de_preferencia("Jonas", 60).

!inicializar_cortina.

+!inicializar_cortina
  <- 	makeArtifact("cortina_quarto","artifacts.Cortina",[],D);
  	   	focus(D);
  	   	.print("Cortina inicializada").
  	   	
+ajuste_cortina 
  <-  !!verificar_ajuste.
      
+closed  <-  .print("Close event from GUIInterface").

+pessoa_reconhecida(P, L) : L == "frente"
  <- .print("Recebi ordens de ajustar cortina baseado em usuario: ", P);
     !verificar_preferencia_cortina(P).

+pessoa_reconhecida(P, L) : L == "saida"
  <- .print("Pessoa saindo: ", P, " no local ", L);
     !fechar_cortina_completamente.

+intruso_detectado(P, L)
  <- .print("ALERTA DE SEGURANCA: Intruso ", P, " detectado no ", L);
     !ativar_modo_defesa_cortina.

+!ativar_modo_defesa_cortina
  <- !fechar_cortina_defesa;
     .print("Cortinas fechadas para reduzir visibilidade do intruso").

+!fechar_cortina_defesa : nivel_abertura(NivelAtual) & NivelAtual > 0
  <- diminuir_nivel;
     .print("Fechando cortina - modo defesa...");
     !fechar_cortina_defesa.

+!fechar_cortina_defesa : nivel_abertura(0)
  <- .print("Cortina completamente fechada - Intruso no escuro").

+!fechar_cortina_completamente : nivel_abertura(NivelAtual) & NivelAtual > 0
  <- diminuir_nivel;
     .print("Fechando cortina...");
     !fechar_cortina_completamente.

+!fechar_cortina_completamente : nivel_abertura(0)
  <- .print("Cortina completamente fechada").

+!verificar_preferencia_cortina(P) : cortina_de_preferencia(P, NivelDesejado)
  <- .print("Preferencia encontrada para ", P, ": nivel ", NivelDesejado);
     !ajustar_cortina(NivelDesejado).

+!verificar_preferencia_cortina(P) : not cortina_de_preferencia(P, _)
  <- .print("Nenhuma preferencia encontrada para ", P, ". Mantendo nivel atual").

+!ajustar_cortina(NivelDesejado) : nivel_abertura(NivelAtual) & NivelAtual < NivelDesejado
  <- aumentar_nivel;
     .print("Aumentando nivel da cortina...");
     !ajustar_cortina(NivelDesejado).

+!ajustar_cortina(NivelDesejado) : nivel_abertura(NivelAtual) & NivelAtual > NivelDesejado
  <- diminuir_nivel;
     .print("Diminuindo nivel da cortina...");
     !ajustar_cortina(NivelDesejado).

+!ajustar_cortina(NivelDesejado) : nivel_abertura(NivelAtual) & NivelAtual == NivelDesejado
  <- .print("Cortina ajustada para o nivel desejado: ", NivelDesejado).
   
+!verificar_cortina: nivel_abertura(Nivel)  
  <- .print("Nivel atual da cortina: ", Nivel).
   
 +!verificar_ajuste: nivel_abertura(N) 
 	<-  .print("Nível de abertura da cortina: ", N).
 	
 +!abrir_cortina: nivel_abertura(N) 
 	<-  .print("Nível de abertura ANTES: ", N);
 		abrir;
 		?nivel_abertura(ND);
 		.print("Nível de abertura DEPOIS: ", ND).