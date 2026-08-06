# Módulo 08 — Index Lifecycle Management (ILM) e Hot-Warm no ECK

> **Objetivo:** automatizar o **ciclo de vida dos índices** — do dado "quente" recém-chegado ao dado antigo arquivado ou deletado — com **ILM**, e desenhar a topologia **hot-warm** usando os **`nodeSets`** do ECK.

> **Pré-requisito:** Módulos 02 e 04 (nodeSets/shards).

---

## 1. O problema que o ILM resolve

Dados de série temporal (logs, métricas, eventos) têm um padrão claro: são **muito acessados quando novos** e **quase nunca acessados quando velhos** — mas continuam ocupando disco caro. Sem automação, alguém precisa, manualmente, criar índices novos, mover os velhos para hardware mais barato, otimizá-los e, por fim, apagá-los. O **ILM** faz tudo isso sozinho, por política.

## 2. As fases do ciclo de vida

Uma **política de ILM** move um índice por até quatro fases, cada uma com ações permitidas:

| Fase | Quando | Ações típicas |
|---|---|---|
| **Hot** | Dado novo, sendo escrito e muito lido | `rollover` (fechar quando grande/velho e abrir outro), `set_priority` |
| **Warm** | Não recebe mais escrita, ainda consultado | `forcemerge`, `shrink`, `allocate` (mover p/ nós warm), read-only |
| **Cold** | Raramente consultado | `allocate` (nós cold), `searchable_snapshot` (Enterprise) |
| **Frozen** | Arquivo, busca rara e lenta | `searchable_snapshot` |
| **Delete** | Fim da vida | `delete` |

Você define, por exemplo: "faça **rollover** ao atingir 50 GB ou 7 dias; após 30 dias vá para **warm** e faça forcemerge; após 90 dias **delete**".

## 3. Rollover e data streams — a peça central

**Rollover** é a ideia de não escrever para sempre no mesmo índice: quando o índice atual atinge um limite (tamanho, idade ou nº de docs), o ILM cria **o próximo** e passa a escrever nele, mantendo os antigos para leitura.

Hoje o mecanismo recomendado para isso são os **data streams**: uma abstração que expõe **um nome único** para escrita (ex.: `logs-app-default`) enquanto, por baixo, mantém uma série de **índices de apoio** (`.ds-logs-...-000001`, `-000002`…) girados pelo rollover. Você escreve/consulta o data stream; o ILM cuida dos bastidores. Isso conecta direto com o conceito de **write alias** do Módulo 05.

Um **index template** amarra tudo: define que índices com certo padrão de nome (`logs-*`) são data streams e usam determinada **política de ILM** e mapeamento.

## 4. O ângulo ECK: hot-warm com `nodeSets`

Aqui a portabilidade brilha. A ação `allocate` do ILM move shards para nós com determinada **característica** (papel `data_hot`/`data_warm` ou atributo). No ECK, você cria esses tiers como **`nodeSets` distintos**:

```yaml
nodeSets:
  - name: hot
    count: 2
    config: { node.roles: ["data_hot", "data_content", "ingest"] }
    # discos rápidos (SSD), mais CPU
  - name: warm
    count: 1
    config: { node.roles: ["data_warm"] }
    # discos maiores e mais baratos
```

Com isso, a fase **warm** do ILM (`allocate` para `data_warm`) faz o operator/Elasticsearch **realocar os shards para os pods warm** automaticamente. Topologia de armazenamento por temperatura vira, de novo, **desenhar a lista de `nodeSets`**.

> **No lab de 16 GB:** rodar 3 nós (2 hot + 1 warm) é pesado. Faremos o ILM completo em **single-node** (as transições de fase acontecem, mas sem realocação física entre tiers) e deixamos a topologia hot-warm como **manifesto de referência**.

## 5. Licença

ILM, rollover, data streams e as fases hot/warm/cold/delete estão disponíveis na licença **Basic** (gratuita). Apenas `searchable_snapshot` (cold/frozen sobre object storage) exige **Enterprise**.

## 6. No laboratório

Você vai (a) criar uma **política de ILM** com hot→warm→delete acelerada (minutos, para ver acontecer), (b) criar um **index template** com data stream apontando para a política, (c) **indexar** documentos e disparar um **rollover**, e (d) acompanhar o índice **mudar de fase** com o `explain`.

---

➡️ [**Laboratório**](laboratorio.md) · Políticas em [`exemplos/`](exemplos/) · topologia em [`manifests/`](manifests/) · [`slides.html`](slides.html)
