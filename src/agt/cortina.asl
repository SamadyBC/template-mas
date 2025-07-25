
cortina_de_preferencia("Jonas", 60).

!inicializar_cortina.

+!inicializar_cortina
  <- 	makeArtifact("cortina_quarto","artifacts.Cortina",[],D);
  	   	focus(D);
  	   	.print("Cortina inicializada").
  	   	
+ajuste_cortina 
  <-  !!verificar_ajuste.
      
+closed  <-  .print("Close event from GUIInterface").

+pessoa_reconhecida(P, L)
  <- .print("Recebi ordens de ajustar cortina baseado em usuario: ", P);
     !verificar_preferencia_cortina(P).

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