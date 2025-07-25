
ilumicao_de_preferencia("Jonas",true).

!inicializar_lampada.

+!inicializar_lampada
  <- 	makeArtifact("lampada_quarto","artifacts.Lampada",[],D);
  	   	focus(D);
  	   	.print("Lampada Inicializada").
  	   	
+interuptor 
  <-  !!verificar_lampada.
      
+closed  <-  .print("Close event from GUIInterface").

+pessoa_reconhecida(P, L) : L == "frente"
  <- .print("Recebi ordens de ajustar ilumincao baseado em usuario: ", P);
     !verificar_preferencia_iluminacao(P).

+pessoa_reconhecida(P, L) : L == "saida"
  <- .print("Pessoa saindo: ", P, " no local ", L);
     !desligar_lampada.

+intruso_detectado(P, L)
  <- .print("ALERTA DE SEGURANCA: Intruso ", P, " detectado no ", L);
     !ativar_modo_defesa_iluminacao.

+!ativar_modo_defesa_iluminacao
  <- !desligar_lampada;
     .wait(2000);
     !ligar_lampada;
     .wait(1000);
     !desligar_lampada;
     .print("Modo defesa: luzes piscando para desorientar intruso").

+!verificar_preferencia_iluminacao(P) : ilumicao_de_preferencia(P, true)
  <- .print("Preferencia encontrada para ", P, ": ligar iluminacao");
     !ligar_lampada.

+!verificar_preferencia_iluminacao(P) : ilumicao_de_preferencia(P, false)
  <- .print("Preferencia encontrada para ", P, ": desligar iluminacao");
     !desligar_lampada.

+!verificar_preferencia_iluminacao(P) : not ilumicao_de_preferencia(P, _)
  <- .print("Nenhuma preferencia encontrada para ", P, ". Mantendo iluminacao atual").

   
 +!verificar_lampada: ligada(false)  
 	<-  .print("Alguém DESLIGOU a Lâmpada").
 	
 +!verificar_lampada: ligada(true)  
 	<-  .print("Alguém LIGOU a Lâmpada").
 	
 +!ligar_lampada
 	<-  ligar;
 		.print("Liguei a Lâmpada!").

 +!desligar_lampada
 	<-  desligar;
 		.print("Desliguei a Lâmpada!").