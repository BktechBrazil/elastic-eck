# Módulo 05 — Index Settings: Mapping, Analyzers e Aliases

> **Objetivo:** controlar **como o Elastic interpreta e indexa cada campo**. Aqui mora a diferença entre uma busca que "simplesmente funciona" e uma que devolve lixo. Módulo de **plano de dados** — roda igual em qualquer deploy, aqui sobre o cluster ECK.

> **Pré-requisito:** Módulos 02 e 03.

---

## 1. Mapping: o "esquema" de um índice

O **mapping** define os campos de um índice e o **tipo** de cada um. Diferente de um banco relacional, o Elastic pode criar o mapping sozinho — o **dynamic mapping** adivinha o tipo no primeiro documento. Isso é ótimo para começar e **perigoso** em produção: um campo que deveria ser `date` vira `text`, um CEP numérico vira `long` e quebra buscas.

Por isso, para dados que importam, definimos **explicit mapping** na criação do índice.

Tipos essenciais: `text`, `keyword`, `long`/`integer`/`double`, `date`, `boolean`, `object` (JSON aninhado) e `nested` (lista de objetos consultável de forma independente).

## 2. `text` × `keyword` — a distinção que resolve tudo

Este é **o** conceito do módulo:

| | `text` | `keyword` |
|---|---|---|
| É **analisado**? | Sim (quebrado em tokens) | Não (valor exato) |
| Bom para | Busca full-text (`match`) | Filtrar, agregar, ordenar (`term`, `terms`) |
| Exemplo | Descrição do produto | Categoria, status, e-mail, SKU |

Como muitas vezes você quer **as duas coisas** no mesmo campo (buscar *e* agregar por "categoria"), o Elastic usa **multi-fields**: o campo é `text` e ganha um sub-campo `.keyword`. É por isso que no Módulo 03 usávamos `category` para `match` e `category.keyword` para `terms`.

```json
"category": {
  "type": "text",
  "fields": { "keyword": { "type": "keyword" } }
}
```

## 3. Analyzers: como o texto vira tokens

Quando um campo `text` é indexado, ele passa por um **analyzer**, um pipeline de três estágios:

```
texto  ──▶ [char filters] ──▶ [tokenizer] ──▶ [token filters] ──▶ tokens indexados
"O Menino Correu!"      (limpa)     (quebra em palavras)   (lowercase, remove stopword, stemming)
                                                     ─▶  [menino, correr]
```

- **Char filters** — limpam o texto bruto (ex.: remover HTML).
- **Tokenizer** — quebra em tokens (o `standard` quebra por espaços/pontuação).
- **Token filters** — transformam tokens: `lowercase`, `stop` (remove "o", "de", "a"), `stemmer` (reduz "correu"→"correr").

O **mesmo analyzer** é aplicado na indexação **e** na busca — por isso procurar "correndo" encontra "correu": ambos viram "correr". A API `_analyze` deixa você **ver os tokens** que saem de qualquer texto/analyzer — ferramenta indispensável para depurar buscas.

Você pode usar analyzers prontos (`standard`, `portuguese`, `english`...) ou montar um **custom analyzer** combinando os três estágios.

## 4. Aliases: um ponteiro estável para índices

Um **alias** é um nome lógico que aponta para um ou mais índices. Parece simples, mas resolve problemas reais:

- **Zero-downtime reindex:** a aplicação sempre lê de `pedidos` (alias). Você cria `pedidos-v2` com o mapping novo, copia os dados (`_reindex`) e **troca o alias** de `pedidos-v1` para `pedidos-v2` atomicamente. Ninguém percebe.
- **Write alias / rollover:** um alias de escrita aponta sempre para o índice "atual" de uma série temporal (base do ILM — Módulo 08).
- **Filtered alias:** um alias que já embute um filtro (ex.: `pedidos-brasil` = `pedidos` onde `pais=BR`).

> **Boa prática:** aplicações nunca deveriam apontar para o **nome físico** de um índice, e sim para um **alias**. Isso te dá liberdade para reindexar e evoluir o mapping sem parar o serviço.

## 5. Por que não dá para "só alterar" um mapping

Campos existentes são, em geral, **imutáveis**: você pode **adicionar** campos, mas não mudar o tipo de um já criado (os dados já foram indexados daquele jeito). A solução padrão é **criar um índice novo com o mapping correto e reindexar** — e é aí que os aliases brilham.

---

➡️ [**Laboratório**](laboratorio.md) · Exemplos em [`exemplos/`](exemplos/) · [`slides.html`](slides.html)
