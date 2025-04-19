# JaCaMo Template Project (v1.2)

You can open this initial JaCaMo project as a template using the above button "Use this template" and then "open in codespace". When the codespace is ready, you can run the application with 

````
./gradlew run
````

You can also use [GitPod](https://gitpod.io/#https://github.com/jacamo-lang/template).

# Avaliação 1: 
Faça uma descrição de alto nível sobre o sistema a ser desenvolvido como projeto da disciplina, incluindo a informação de domínio, tipos de agentes a serem desenvolvidos, e responsabilidades de cada tipo de agente a ser desenvolvido.

## Sistema de Controle e Gerenciamento de Estufas Automatizadas:
De forma geral, o sistema multi-agentes a ser desenvolvido tem como objetivo simular o controle de estufas automatizadas. Agentes serão implementados com o intuito de automatizar o processo de cultivo e aumentar a eficiência do sistema como um todo. A tomada de decisões dos agentes será baseada em dados extraídos de sensores utilizados nas estufas, bem como em banco de dados e também em informações relevantes programadas no código do agente.

### Principais tipos de agentes:
- Agentes Sensores: esses agentes serão responsáveis por obter e transferir dados dos sensores. Por exemplo: agente sensor de umidade, sensor de temperatura, sensor de incidência solar e sensor de iluminação.
- Agentes Atuadores: esses agentes serão responsáveis por realizar modificações no ambiente baseado nos dados obtidos dos sensores. Exemplo: agente controlador do ar condicionado, agente controlador do sistema de irrigação.
- Agentes de Sincronização: tais agentes serão responsáveis por sincronizar os dados obtidos armazenando-os em bancos de dados de maneira eficaz, segura e persistente.
- Agentes orquestradores: gerenciam o comportamento geral do sistema, realizando a comunicação entre agentes e garantindo a maior cooperação entre os demais agentes.


### Agente implementados:
#### - Agente Controlador de Ar Condicionado.

| Tipo | Responsabilidade | Crenças | Objetivos | Planos|
| -------- | ----- | ----------- |----|------ |
| Atuador| Controlar AC | temp_ideal(Cultivo, Temperatura), producao(Cultivo, Local), temp_atual(Temperatura)| regular_temperatura(Local) | regular_temperatura(Local), verificar_temp(Local, Cultivo), aquecer(C), resfriar(C)|
| | | | | |

#### Funcionamento:

Este agente, conforme o paradigma da programação orientada a agentes, permanece executando de maneira cíclica seu código, o qual tem como objetivo regular a temperatura do ambiente controlando o ar condicionado. Inicialmente, o plano regular_temperatura() será iniciado com a informação de qual ambiente deseja-se regular a temperatura. Com base no local, o agente obtém a informação da cultura presente nesse ambiente. Por fim, obtém-se a temperatura ideal para a cultura em questão.

A partir do objetivo de regular a temperatura outros planos são utilizados. O plano de verificar_temp(), que possui três implementações, basicamente utiliza-se de inferências para determinar se o ambiente deve ser resfriado, aquecido ou mantido na temperatura atual. Tais inferências são todas feitas a partir da base de crenças do agente. A partir das verificações de contexto em cada um das inferências então os planos específicos são executados.

Os últimos planos a entrarem em ação são os responsáveis pela modificação do ambiente de fato. Ou seja, os planos de aquecer() e resfriar(). Esses planos basicamente utilizam-se dos dados obtidos nos planos anteriores para realizar suas tarefas.

#### Links:
- Codigo Fonte do agente: [temperature_Controller](https://github.com/SamadyBC/template-mas/blob/main/src/agt/temperature_Controller.asl)
- Inicializacao do agente: [main](https://github.com/SamadyBC/template-mas/blob/main/main.jcm)
