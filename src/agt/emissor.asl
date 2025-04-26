/* Initial beliefs, rules and inferences */

// beliefs: idioma(""), cumprimento("", ""), learn("", "")

/* Initial goals */

// !comunicar. Adicionado no main.jcm

/* Initial plans */

+!comunicar: idioma(I) <- !transmitir_comunicado(I);
  .wait(5000);
  !comunicar.

+!transmitir_comunicado(Idioma): cumprimento(Idioma, Cumprimento)  <- .print(Cumprimento);
  .broadcast(tell, mensagem(Cumprimento)).

+mensagem(Msg)[source(Fonte)]: Msg == "Hello" & learn(Idioma, Cumprimento) <- .print("Mensagem recebida de: ", Fonte);
  .print("Mensagem: ", Msg);
  .send(Fonte, achieve, learn(Idioma, Cumprimento)).
 
