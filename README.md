# JaCaMo Template Project (v1.2)

You can open this initial JaCaMo project as a template using the above button "Use this template" and then "open in codespace". When the codespace is ready, you can run the application with

```
./gradlew run
```

You can also use [GitPod](https://gitpod.io/#https://github.com/jacamo-lang/template).

# Avaliação Final:

Como tarefa final, você deve implementar os seguintes cenários de uso para uma smart home:

Cenário em que o proprietário chega em casa: o agente da câmera identifica ele em frente a porta de entrada, destranca e abre a porta da casa e comunica aos agentes do ar-condicionado e iluminação (agentes de luzes e cortinas) para adequar o ambiente baseado nas preferências do proprietário (definidas anteriormente).

Cenário em que o proprietário sai da casa: aqui o agente da câmera identifica que o proprietário está saindo de casa e envia aos agentes do ar-condicionado e da iluminação para desligarem e para que o agente da porta feche e tranque a porta.

Cenário em que o agente de câmera detecta um indivíduo desconhecido dentro da casa: o agente câmera deve comunicar aos outros agentes de que há um intruso na residência. Os agentes devem tentar dificultar ao máximo as ações do suspeito, seja ligando o ar-condicionado em temperaturas extremas, apagando as luzes, fechando a cortina, entre outras possibilidades. Seja criativo para tentar fazer com que ele saia da residência!

A smart home possui 3 grupos principais de agentes: os agentes de climatização (ar-condicionado), iluminação (luz e cortina) e segurança (câmera e porta). Tente explorar esses três grupos no desenvolvimento e fique a vontade em testar e criar outros cenários que desejar!

## Sistema de Controle de Casa Automatizada:

Este sistema implementa uma casa inteligente usando a linguagem Jason com múltiplos agentes especializados que se comunicam e coordenam suas ações baseadas em diferentes cenários de reconhecimento de pessoas e situações de segurança.

### Principais tipos de agentes:

#### Agente Camera:

- **Função Principal**: Reconhecimento e identificação de pessoas através de interface gráfica
- **Artefato**: artifacts.Camera - Interface que permite simular detecção manual de pessoas
- **Propriedades Observáveis**:
  - `ligada` (boolean): Status da câmera
  - `local` (String): Local onde a pessoa foi detectada ("frente", "saida", "interior")
  - `pessoa_presente` (String): Nome da pessoa detectada
- **Base de Conhecimento**:
  - `pessoa_autorizada("Jonas")`: Lista de pessoas autorizadas no sistema
- **Gatilhos de Comunicação**:
  - Pessoa autorizada na "frente": `.send(fechadura, tell, pessoa_reconhecida(P, L))`
  - Pessoa não autorizada no "interior": Envia `intruso_detectado(P, L)` para todos os agentes

#### Agente Fechadura:

- **Função Principal**: Controle de acesso e segurança da porta principal
- **Artefato**: artifacts.Fechadura - Interface para controle de porta e fechadura
- **Propriedades Observáveis**:
  - `trancada` (boolean): Status da fechadura
  - `fechada` (boolean): Status da porta
- **Operações**: `destrancar`, `trancar`, `abrir`, `fechar`
- **Coordenação**: Atua como hub de comunicação, repassando mensagens para outros agentes
- **Comportamentos por Cenário**:
  - Entrada: Destranca e abre a porta, comunica outros agentes
  - Saída: Fecha e tranca a porta
  - Intruso: Tranca a porta para impedir fuga

#### Agente Ar Condicionado:

- **Função Principal**: Controle de climatização baseado em preferências e situações
- **Artefato**: artifacts.ArCondicionado - Interface para controle de temperatura
- **Propriedades Observáveis**:
  - `temperatura_ambiente` (int): Temperatura atual do ambiente
  - `temperatura_ac` (int): Temperatura configurada no AC
  - `ligado` (boolean): Status do ar condicionado
- **Base de Conhecimento**: `temperatura_de_preferencia("Jonas", 25)`
- **Comportamentos por Cenário**:
  - Entrada: Ajusta temperatura conforme preferência do usuário
  - Saída: Desliga o ar condicionado
  - Intruso: Define temperatura extrema (10°C) para causar desconforto

#### Agente Lâmpada:

- **Função Principal**: Controle de iluminação baseado em preferências e situações
- **Artefato**: artifacts.Lampada - Interface para controle de iluminação
- **Propriedades Observáveis**: `ligada` (boolean): Status da lâmpada
- **Base de Conhecimento**: `ilumicao_de_preferencia("Jonas", true)`
- **Comportamentos por Cenário**:
  - Entrada: Liga/desliga conforme preferência do usuário
  - Saída: Desliga a iluminação
  - Intruso: Efeito de luzes piscando para desorientar

#### Agente Cortina:

- **Função Principal**: Controle de cortinas baseado em preferências e situações
- **Artefato**: artifacts.Cortina - Interface para controle de nível de abertura
- **Propriedades Observáveis**: `nivel_abertura` (int): Nível de abertura (0-100)
- **Operações**: `aumentar_nivel`, `diminuir_nivel`, `abrir`, `fechar`
- **Base de Conhecimento**: `cortina_de_preferencia("Jonas", 60)`
- **Comportamentos por Cenário**:
  - Entrada: Ajusta nível conforme preferência (ajuste recursivo até atingir valor desejado)
  - Saída: Fecha completamente as cortinas
  - Intruso: Fecha completamente para reduzir visibilidade

### Funcionamento:

#### Fluxo de Comunicação:

1. **Agente Camera** detecta movimento e identifica pessoa
2. **Verificação de Autorização**: Consulta base de crenças `pessoa_autorizada(P)`
3. **Decisão de Fluxo**: Baseada no status da pessoa (autorizada/não autorizada) e local detectado
4. **Comunicação Coordenada**: Uso de `.send()` para comunicação direcionada entre agentes
5. **Execução Paralela**: Todos os agentes executam suas ações simultaneamente

#### Gatilhos de Fluxo de Trabalho:

**Cenário 1 - Entrada do Proprietário (Local: "frente")**:

- Trigger: `pessoa_reconhecida(P, "frente")` onde `pessoa_autorizada(P)`
- Fechadura: Destranca e abre porta + comunica outros agentes
- Ar-condicionado: Ajusta temperatura conforme `temperatura_de_preferencia(P, Temp)`
- Lâmpada: Liga/desliga conforme `ilumicao_de_preferencia(P, Status)`
- Cortina: Ajusta nível conforme `cortina_de_preferencia(P, Nivel)`

**Cenário 2 - Saída do Proprietário (Local: "saida")**:

- Trigger: `pessoa_reconhecida(P, "saida")` onde `pessoa_autorizada(P)`
- Fechadura: Fecha e tranca porta + comunica outros agentes
- Ar-condicionado: Desliga sistema
- Lâmpada: Desliga iluminação
- Cortina: Fecha completamente (nível 0)

**Cenário 3 - Detecção de Intruso (Local: "interior")**:

- Trigger: `intruso_detectado(P, "interior")` onde `not pessoa_autorizada(P)`
- Fechadura: Tranca porta para impedir fuga
- Ar-condicionado: Temperatura extrema (10°C)
- Lâmpada: Efeito estroboscópico (liga/desliga alternado)
- Cortina: Fecha completamente para criar ambiente claustrofóbico

### Fluxo de Execução de Testes:

1. **Inicialização**: Cada agente cria seu artefato correspondente e foca nele
2. **Configuração de Preferências**: Definir crenças de preferência para usuários autorizados
3. **Simulação via Interface**: Usar interfaces gráficas dos artefatos para simular detecções
4. **Observação de Logs**: Acompanhar prints dos agentes para verificar coordenação
5. **Teste de Cenários**:
   - Testar pessoa autorizada na "frente"
   - Testar pessoa autorizada na "saida"
   - Testar pessoa não autorizada no "interior"

### Observacao:

    O fluxo de execução do projeto está bem definido, porém a implementação foi pensada de maneira linear. O gatilho para o processo é o envio do movimento através da interface gráfica. Qualquer alteração nesse fluxo não foi implementada por falta de tempo.

### Tecnologias Utilizadas:

- **Jason**: Linguagem de programação para sistemas multiagentes
- **CArtAgO**: Framework para artefatos e ambientes
- **Java Swing**: Interfaces gráficas para simulação de sensores
