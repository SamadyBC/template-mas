
!inicializar_camera.

+!inicializar_camera
  <- 	makeArtifact("camera_quarto","artifacts.Camera",[],D);
  	   	focus(D).
  	   	
+movimento 
  <-  !!verificar_pessoa.
      
+closed  <-  .print("Close event from GUIInterface").

+!verificar_pessoa : pessoa_presente(P) & local(L) & pessoa_autorizada(P)
  <- .print("Pessoa autorizada: ", P, " reconhecida no local ", L);
    .send(fechadura, tell, pessoa_reconhecida(P, L)).

+!verificar_pessoa : pessoa_presente(P) & local(L) & not pessoa_autorizada(P)
  <- .print("Pessoa NÃO autorizada: ", P, " detectada no local ", L).
