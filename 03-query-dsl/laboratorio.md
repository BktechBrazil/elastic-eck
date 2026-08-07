# Laboratório 03 — Query DSL na prática

> **Pré-requisito:** Módulo 02 com os Sample data carregados.
> **Tempo estimado:** 30–40 minutos.

Use o **Kibana → Dev Tools → Console**. Todas as consultas estão prontas em [`exemplos/consultas-dev-tools.txt`](exemplos/consultas-dev-tools.txt) — abra o arquivo, cole no Console e execute bloco a bloco. Abaixo, o roteiro comentado.

> Prefere terminal? Exponha o ES e use `curl`:
> ```bash
> source _assets/versions.env
> PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
> pkill -f "port-forward.*9200" || true
> kubectl -n elastic port-forward service/lab-es-es-http 9200 &
> sleep 2
>```

---

## Parte A — Entender a resposta

### Passo 1 — `match_all` e anatomia do resultado (consulta 1)

Rode a consulta 1. Observe na resposta:
- `hits.total.value` — quantos documentos existem.
- `hits.hits[]._source` — o conteúdo de cada documento.
- `took` — tempo em ms.

**Reflita:** mudar `size` altera **quantos** retornam, não **quantos casaram**.

## Parte B — As duas famílias

### Passo 2 — Full-text vs term-level (consultas 2 e 3)

- A consulta 2 (`match`) devolve documentos ordenados por **`_score`** — relevância.
- A consulta 3 (`term`) é um filtro exato em `customer_gender` (keyword): todos com o **mesmo `_score`**.

**Exercício:** troque a consulta 3 para `term` em `category` (sem `.keyword`) e observe que **não casa nada** — porque `category` é `text` e foi analisado; o valor exato mora em `category.keyword`.

### Passo 3 — Range (consulta 4)

Filtre pedidos entre R$ 50 e R$ 100. Troque os limites e confirme a variação de `hits.total`.

## Parte C — Compondo com `bool`

### Passo 4 — must / filter / must_not (consulta 5)

Rode a consulta 5. Note que o `filter` de preço **não altera o `_score`** — só restringe. Essa é a forma idiomática e performática de consultar.

**Exercício:** mova a cláusula de `range` de `filter` para `must` e compare os `_score`. Conceitualmente o resultado é o mesmo, mas em `filter` é cacheável.

### Passo 5 — Ordenação e projeção (consulta 6)

Retorne só 3 campos, ordenados por preço decrescente. Útil para relatórios enxutos.

## Parte D — Agregações

### Passo 6 — Metric simples (consulta 7)

`size: 0` diz "não me devolva documentos, só o resumo". Veja o **ticket médio**.

### Passo 7 — Bucket + metric aninhada (consulta 8)

Receita por categoria. Esta é a estrutura mental de **quase todo painel do Kibana**: agrupar (bucket) e medir (metric).

### Passo 8 — Série temporal (consulta 9)

`date_histogram` agrupa por dia. Troque `calendar_interval` para `week` e observe.

### Passo 9 — Explorando os web logs (consultas 10 e 11)

Filtre erros `404` ordenados por tempo, e conte produtos distintos com `cardinality`.

---

## Desafios (para fixar)

1. **Top 5 clientes por gasto total** (`terms` em `customer_full_name.keyword` + `sum` de `taxful_total_price`).
2. **Receita por dia apenas de "Women's Clothing"** (combine `filter` + `date_histogram` + `sum`).
3. Nos logs, **quantos bytes** foram servidos por país (`terms` em `geo.dest` + `sum` de `bytes`).

> Soluções: monte no Dev Tools combinando os blocos 8 e 9. Se travar, veja o padrão "bucket contém metric".

---

## ✅ Você aprendeu

- A diferença entre **full-text** e **term-level** e quando usar cada uma.
- A compor consultas com **`bool`** e por que `filter` é preferível a `must` para critérios exatos.
- A resumir dados com **aggregations** (bucket + metric).

➡️ **Módulo 04** — como esses documentos ficam distribuídos em **nós, shards e segments**, e como isso aparece no ECK.
