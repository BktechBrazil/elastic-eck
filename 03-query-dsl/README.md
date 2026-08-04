# Módulo 03 — Explorando os Dados: Query DSL

> **Objetivo:** aprender a buscar, filtrar e agregar dados no Elasticsearch usando a **Query DSL** (Domain Specific Language) — a linguagem de consultas em JSON do Elastic. Este é um módulo de **plano de dados**: vale igual em qualquer forma de deploy (ECK ou não), mas aqui rodamos tudo contra o cluster que subimos no ECK.

> **Pré-requisito:** Módulo 02 concluído, com os **Sample data** carregados (`kibana_sample_data_ecommerce`, `kibana_sample_data_logs`).

---

## 1. Como o Elasticsearch "pensa"

Antes de consultar, três ideias fundamentais:

**Documento e índice.** Um **documento** é um JSON (ex.: um pedido de e-commerce). Um **índice** é uma coleção de documentos parecidos (ex.: todos os pedidos). Buscar é perguntar a um índice "quais documentos batem com este critério?".

**O `_search` e a estrutura da resposta.** Toda consulta vai para `GET /<indice>/_search` com um corpo JSON. A resposta traz `hits.total` (quantos casaram), `hits.hits` (os documentos, os melhores primeiro) e, quando pedimos, `aggregations`.

**Relevância (`_score`).** Em buscas de texto, o Elastic não devolve só "casou ou não" — ele **pontua** o quão bem cada documento casa, e ordena por isso. Esse é o coração de um motor de busca.

## 2. As duas famílias de consulta

Entender essa divisão evita 90% da confusão de quem começa:

| Família | Pergunta que responde | Afeta `_score`? | Exemplos |
|---|---|---|---|
| **Full-text** (texto) | "Quão relevante é este texto?" | **Sim** | `match`, `multi_match`, `match_phrase` |
| **Term-level** (exato) | "Este valor é exatamente igual?" | Não (filtro) | `term`, `terms`, `range`, `exists` |

Regra prática: use **full-text** em campos `text` (descrições, mensagens) e **term-level** em campos `keyword`, números, datas e booleanos (categorias, status, preços). Um mesmo campo costuma existir nas duas formas — ex.: `category` (text) e `category.keyword` (exato).

## 3. `query` vs `filter` — relevância e velocidade

Dentro de uma consulta `bool`, você combina cláusulas:

- **`must`** — precisa casar **e conta para o `_score`**.
- **`should`** — opcional; se casar, **aumenta o `_score`**.
- **`filter`** — precisa casar, mas **não pontua** (e é **cacheável**, logo mais rápido).
- **`must_not`** — precisa **não** casar.

> **Dica de performance:** tudo que é "sim/não" (intervalos de data, status, categoria) deve ir em **`filter`**, não em `must`. Você ganha velocidade e cache sem perder corretude.

## 4. Agregações — de busca a análise

Enquanto a `query` seleciona documentos, as **aggregations** os **resumem**. Duas categorias:

- **Bucket** — agrupam documentos (ex.: `terms` = "por categoria", `date_histogram` = "por dia").
- **Metric** — calculam números sobre um grupo (ex.: `avg`, `sum`, `max`, `cardinality`).

Você aninha uma na outra: "por categoria (bucket), qual o ticket médio (metric)". É assim que os dashboards do Kibana (Módulo 07) são construídos por baixo.

## 5. Onde executar

- **Kibana → Dev Tools → Console**: o jeito mais confortável (autocompletar, formatação). Cole os exemplos de [`exemplos/consultas-dev-tools.txt`](exemplos/consultas-dev-tools.txt).
- **`curl`** contra o `port-forward` do ES: bom para automação/scripts.

---

➡️ [**Laboratório**](laboratorio.md) · Consultas prontas em [`exemplos/`](exemplos/) · [`slides.html`](slides.html)
