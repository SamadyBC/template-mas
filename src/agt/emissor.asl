/* Initial beliefs, rules and inferences */

  //idioma()
  //idioma("Portugues"), cumprimento("Olá") learn("portuguese")

  // beliefs: idioma("Portugues"), cumprimento("Portugues", "Olá"), learn("portuguese")

/* Initial goals */

// !comunicar. Como esse objetivo eh adicionado na declaracao do agente

/* Initial plans */

+!comunicar <- !cumprimentar; //alterar para transmitir
  .wait(5000);
  !comunicar.

+!cumprimentar: idioma(I) <- .print("Idioma: ", I);
    !transmitir_comunicado(Idioma).

+!transmitir_comunicado(Idioma) <- !buscar_comprimento(Idioma).

+!buscar_comprimento(Idioma): cumprimento(Idioma, Cumprimento) <- .print(Cumprimento);
  .broadcast(tell, mensagem(Cumprimento));.

+mensagem(Msg)[source(Fonte)]: Msg == "Hello" & learn(Y)<- .print("Mensagem recebido de: ", Fonte);
  .print("Mensagem: ", Msg);
  .send(Fonte, achieve, learn(Y)). //.send(Fonte, achieve, learn("portuguese")).
