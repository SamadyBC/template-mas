// Agent gui in project aula10

/* Initial beliefs and rules */

temperatura_de_preferencia("Jonas",25).

/* Initial goals */

!inicializar_AC.

+!inicializar_AC
  <- 	makeArtifact("ac_quarto","artifacts.ArCondicionado",[],D);
  	   	focus(D);
		.print("Inicializado ar condicionado!").
  	   	//!definir_temperatura;
  	   	//!!climatizar.

+alterado : temperatura_ambiente(TA) & temperatura_ac(TAC)
  <-  .drop_intention(climatizar);
  	  .print("Houve interação com o ar condicionado!");
  	  .print("Temperatura Ambiente: ", TA);
 	  .print("Temperatura Desejada: ", TAC);
  	  !!climatizar.
      
+closed  <-  .print("Close event from GUIInterface").

+pessoa_reconhecida(P, L)
  <- .print("Recebi ordens de ajustar temperatura baseado em usuario: ", P);
     !verificar_preferencia_temperatura(P).

+!verificar_preferencia_temperatura(P) : temperatura_de_preferencia(P, TP)
  <- .print("Preferencia encontrada para ", P, ": ", TP, " graus");
     definir_temperatura(TP);
     !climatizar.

+!verificar_preferencia_temperatura(P) : not temperatura_de_preferencia(P, _)
  <- .print("Nenhuma preferencia encontrada para ", P, ". Mantendo temperatura atual").

   
 +!definir_temperatura: temperatura_ambiente(TA) & temperatura_ac(TAC) 
 			& temperatura_de_preferencia(User,TP) & TP \== TA & ligado(false)
 	<-  definir_temperatura(TP);
 		.print("Definindo temperatura baseado na preferência do usuário ", User);
 		.print("Temperatura: ", TP).
 	
 +!definir_temperatura: temperatura_ambiente(TA) & temperatura_ac(TAC) & ligado(false)
 	<-  .print("Usando última temperatura");
 		.print("Temperatura: ", TAC).
 		
 		
 +!climatizar: temperatura_ambiente(TA) & temperatura_ac(TAC) & TA \== TAC & ligado(false)
 	<-   ligar;
 		.print("Ligando ar condicionado...");
 		.print("Temperatura Ambiente: ", TA);
 		.print("Temperatura Desejada: ", TAC);
 		.wait(1000);
 		!!climatizar.
 		
 +!climatizar: temperatura_ambiente(TA) & temperatura_ac(TAC) & TA \== TAC & ligado(true) 
 	<-  .print("Aguardando regular a temperatura de ", TA, " para ", TAC, "...");
 		.wait(4000);
 		!!climatizar.
 		 	
  +!climatizar: temperatura_ambiente(TA) & temperatura_ac(TAC) & TA == TAC & ligado(true) 
 	<-   desligar;
 		.print("Desligando ar condicionado...");
 		.print("Temperatura Ambiente: ", TA);
 		.print("Temperatura Desejada: ", TAC).

 +!climatizar 
 	<- 	.print("Não foram implementadas outras opções.");
 		.print("Temperatura regulada.").


