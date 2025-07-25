
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

+!verificar_pessoa : pessoa_presente(P) & local("interior") & not pessoa_autorizada(P)
  <- .print("INTRUSO DETECTADO: ", P, " no interior da casa!");
     .send(fechadura, tell, intruso_detectado(P, "interior"));
     .send(ar_condicionado, tell, intruso_detectado(P, "interior"));
     .send(lampada, tell, intruso_detectado(P, "interior"));
     .send(cortina, tell, intruso_detectado(P, "interior")).

+!verificar_pessoa : pessoa_presente(P) & local(L) & not pessoa_autorizada(P)
  <- .print("Pessoa NÃO autorizada: ", P, " detectada no local ", L).

  
