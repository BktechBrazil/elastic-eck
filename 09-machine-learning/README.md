# Módulo 09 — Elastic Machine Learning

> **Objetivo:** usar o **Machine Learning** nativo do Elastic para **encontrar padrões e anomalias automaticamente** nos dados, sem escrever modelos. Ver como habilitar o papel de nó **ml** no ECK e as implicações de recurso no lab.

> **Pré-requisito:** Módulos 02 e 07 (dados + Kibana). **Atenção à licença e aos recursos — leia as seções 2 e 6.**

---

## 1. O que o Elastic ML faz

O ML do Elastic aprende o **comportamento normal** dos seus dados e aponta o que foge disso — sem você definir regras ("se > X, alerta"). Ele se divide em duas famílias:

**Anomaly Detection (detecção de anomalias)** — para **séries temporais**. Aprende a linha de base de uma métrica (ex.: requisições por minuto, latência, bytes) considerando sazonalidade (dia/noite, fim de semana) e sinaliza desvios com uma **pontuação de anomalia** (0–100). É o caso de uso mais comum: "me avise quando o tráfego, os erros ou o volume fugirem do normal — sem eu ter que dizer qual é o normal".

**Data Frame Analytics (DFA)** — análises sobre dados tabulares: **outlier detection** (achar registros atípicos), **regression** (prever um número) e **classification** (prever uma categoria). Usa aprendizado supervisionado/não-supervisionado e gera um modelo que pode ser aplicado a novos dados via **inference**.

> Há ainda **NLP/inference** (modelos de linguagem para embeddings, NER, etc.), que conecta com o Módulo 12 (GenAI). Aqui focamos em anomaly detection, o carro-chefe.

## 2. Licença — importante!

Machine Learning é um recurso **comercial**: exige licença **Platinum** ou **Enterprise**. Na licença **Basic** (gratuita, padrão do ECK) o ML **não** está disponível.

Para o laboratório, ative a **avaliação de 30 dias** (trial), que habilita todos os recursos:

- **Kibana → Stack Management → License Management → "Start a 30-day trial"**, ou
- via API: `POST /_license/start_trial?acknowledge=true`.

> O trial é por cluster e dura 30 dias; depois volta para Basic. Suficiente para o curso.

## 3. Como funciona a detecção de anomalias

Você cria um **job** de anomaly detection escolhendo:

- **Bucket span** — a granularidade temporal (ex.: 15m). O ML resume os dados em *buckets* desse tamanho.
- **Detector** — a função + campo a analisar: `count` (contagem de eventos), `mean(latência)`, `sum(bytes)`, `high_count`, etc.
- **Partition/by field** (opcional) — analisar **por entidade** separadamente (ex.: uma linha de base por `host`, por `url`).

O ML então modela a métrica, aprende sazonalidade e, para cada bucket, calcula quão **improvável** é o valor observado. O resultado aparece no **Anomaly Explorer** e no **Single Metric Viewer**, com a banda de "normalidade" e os pontos anômalos destacados.

Tipos de assistente no Kibana: **Single metric** (uma métrica), **Multi-metric** (várias, particionadas por entidade) e **Population** (comparar entidades contra o comportamento da população).

## 4. O ângulo ECK: o papel de nó `ml`

Jobs de ML rodam em nós com o papel **`ml`** (processos nativos separados da JVM). No ECK, basta incluir `ml` nos `node.roles` de um `nodeSet` e reservar memória para isso:

```yaml
nodeSets:
  - name: default
    config:
      node.roles: ["master","data","ingest","ml","remote_cluster_client"]
```

Em produção, é comum um `nodeSet` **dedicado a ML** (nós com bastante RAM e o papel `ml`), separando a carga de ML da carga de dados. No lab single-node, adicionamos `ml` ao nó único.

## 5. Memória de ML

O ML tem um limite próprio de memória (`xpack.ml.max_machine_memory_percent`, ~30% por padrão) e cada job reserva um **model memory limit**. Isso é **além** do heap da JVM do Elasticsearch. Ou seja: ML compete por RAM com todo o resto.

## 6. Recursos no lab de 16 GB — leia antes

Este é um dos módulos **mais pesados**. Recomendações:

- **Rode isolado:** pare coletores do Módulo 06 e outros clusters antes.
- **Suba a RAM do nó** para o ML ter espaço (o manifest deste módulo usa `requests.memory: 6Gi` e heap 3 GB).
- Use **datasets pequenos** (os Sample data bastam) e **poucos jobs**.
- Se possível, **aumente a VM para 32 GB** temporariamente para este módulo e o 12.

## 7. No laboratório

Você vai (a) **ativar o trial**, (b) aplicar um cluster com o papel `ml` habilitado, (c) criar um **job single-metric** de anomalia sobre o volume dos web logs de amostra, e (d) explorar as anomalias no **Anomaly Explorer**.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
