# Laboratório 05 — Mapping, Analyzers e Aliases

> **Pré-requisito:** Módulos 02 e 03. Cluster `lab-es` no ar (se você trocou para `topo-es` no Módulo 04, volte ao `lab-es`).
> **Tempo estimado:** 30–40 minutos.

Use o **Kibana → Dev Tools**. Todos os comandos estão em [`exemplos/dev-tools.txt`](exemplos/dev-tools.txt). Roteiro comentado abaixo.

---

## Parte A — Enxergar o mapping

### Passo 1 — Mapping dinâmico (comando 1)

Veja o mapping que o Elastic **inferiu** dos dados de amostra. Repare quantos campos `text` ganharam um sub-campo `.keyword`.

### Passo 2 — Anatomia de um multi-field (comando 2)

Confirme que `category` é `text` **e** tem `category.keyword`. Este é o mecanismo que permite `match` (no `text`) e `terms`/ordenação (no `.keyword`) no mesmo campo.

## Parte B — Analyzers na prática

### Passo 3 — Ver os tokens (comandos 3 e 4)

Rode `_analyze` com o analyzer `standard` e depois `portuguese`. Compare a saída:
- `standard`: minúsculas e separação por palavras.
- `portuguese`: além disso, **remove stopwords** ("os", "estavam") e aplica **stemming** ("correndo" → radical).

**Exercício:** rode `_analyze` com `text: "correndo"` e depois com `text: "corrida"` no analyzer `portuguese`. Eles produzem o **mesmo radical**? É por isso que a busca cruza os dois.

## Parte C — Mapping explícito + analyzer custom

### Passo 4 — Criar o índice `catalogo` (comando 5)

Aplique o índice com mapping explícito e um **analyzer custom** (`html_strip` + `standard` + `lowercase` + stopwords/stemmer PT). Cada campo tem o tipo certo: `sku` é `keyword`, `preco` é `double`, `criado_em` é `date`.

### Passo 5 — Provar o full-text com stemming (comandos 6 e 7)

Indexe o documento e busque `match: { nome: "correr" }` — ele encontra "corrida" graças ao stemmer. Depois confirme que `term` exato funciona em `sku` (keyword).

**Exercício:** tente `term` em `nome` (text) e observe que **não casa** — reforçando a lição do Módulo 03.

## Parte D — Aliases e reindex sem downtime

### Passo 6 — Criar e usar um alias (comando 8)

Crie o alias `produtos` → `catalogo`. Consulte `produtos` e veja que funciona como o índice.

### Passo 7 — Evoluir o mapping via reindex (comando 9)

Suponha que agora precisamos do campo `marca`. Como não dá para mudar o índice existente com segurança, criamos `catalogo-v2` (mapping novo), copiamos com `_reindex` e **trocamos o alias atomicamente**. A aplicação, que sempre leu de `produtos`, **não percebe a troca**.

**Validação:**

```text
GET produtos/_search      # agora serve de catalogo-v2, sem interrupção
```

### Passo 8 — Filtered alias (comando 10)

Crie `produtos-ativos` = `catalogo-v2` filtrando `ativo: true`. Consulte-o: só retornam ativos, sem precisar repetir o filtro na aplicação.

---

## Desafios

1. Crie um índice `artigos` com um campo `corpo` usando o analyzer `portuguese` e um campo `tags` como `keyword`. Indexe 2 documentos e prove o stemming.
2. Faça um `_reindex` que **transforma** dados no caminho (use `script` no reindex para, por exemplo, colocar `sku` em maiúsculas).

---

## ✅ Você aprendeu

- A diferença entre **dynamic** e **explicit mapping** e por que definir o esquema importa.
- O par **`text` × `keyword`** e o mecanismo de **multi-fields**.
- Como um **analyzer** transforma texto em tokens (char filter → tokenizer → token filter) e como depurar com `_analyze`.
- A usar **aliases** para reindexar e evoluir mappings **sem downtime**.

➡️ **Módulo 06** — como colocar dados para dentro: **ingestão com Elastic Agent, Fleet e Beats no Kubernetes**.
