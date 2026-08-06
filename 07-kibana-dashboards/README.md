# Módulo 07 — Kibana: Gráficos, Dashboards e Gestão de Dados

> **Objetivo:** transformar dados em **informação visual**. Aprender a explorar dados no Discover, construir visualizações com o **Lens**, montar **dashboards** interativos com filtros e controles, e gerir os *saved objects*. Módulo de plano de dados — roda igual em qualquer deploy, aqui sobre o cluster ECK.

> **Pré-requisito:** Módulo 02 com os **Sample data** carregados (eCommerce e web logs).

---

## 1. O ponto de partida: Data Views

O Kibana não lê índices diretamente; ele lê **Data Views** (antigamente "index patterns"). Um Data View é um "óculos" que aponta para um ou mais índices por padrão de nome (ex.: `kibana_sample_data_ecommerce`, ou `logs-*` para vários) e define qual campo é o **timestamp** (essencial para dados temporais). **Tudo** no Kibana — Discover, Lens, dashboards, alertas — começa por um Data View.

## 2. Discover: explorar antes de visualizar

O **Discover** é onde você **conhece** os dados: vê documentos brutos, filtra por tempo, adiciona colunas, e faz buscas com **KQL** (Kibana Query Language) — uma sintaxe mais simples que a Query DSL para o dia a dia:

```
customer_gender : "FEMALE" and taxful_total_price > 50
response.keyword : "404" and url : *login*
```

Discover é a ferramenta de **investigação** (um erro, um pico, um cliente); dashboards são a de **acompanhamento**.

## 3. Lens: a forma moderna de visualizar

O **Lens** é o editor de visualizações *drag-and-drop*: você arrasta campos e ele **sugere o gráfico** e escolhe a agregação apropriada. Por baixo, é a mesma dupla do Módulo 03 — **bucket** (eixo X / fatias) + **metric** (eixo Y / tamanho). Entender aquela estrutura faz o Lens parecer óbvio.

Tipos de visualização mais usados: **barras/colunas**, **linha/área** (séries temporais), **pizza/donut** (proporções), **métrica** (um número grande, KPI), **tabela**, **mapa** (com dados geográficos), **heatmap** e **treemap**.

> **Dica:** comece sempre pela pergunta ("receita por categoria ao longo do tempo?") e deixe o Lens propor. Só depois refine o tipo de gráfico.

## 4. Dashboards: juntando tudo

Um **dashboard** é um painel com várias visualizações que **respondem juntas** ao mesmo filtro de tempo e às mesmas buscas. O que o torna poderoso:

- **Filtro global de tempo** — muda o período de todos os painéis de uma vez.
- **Controls** — menus suspensos/sliders no topo do dashboard (ex.: escolher a categoria, faixa de preço) que filtram tudo interativamente, sem editar nada.
- **Drill-down / interações** — clicar numa fatia filtra o restante do painel.
- **Filtros e KQL** na barra de busca — aplicados ao dashboard inteiro.

## 5. Gestão de dados e Saved Objects

Tudo que você cria no Kibana (Data Views, visualizações, dashboards, buscas salvas) é um **Saved Object**, versionável e **exportável** em **Stack Management → Saved Objects** (formato `.ndjson`). É assim que você **versiona um dashboard em Git** ou o **promove entre ambientes** (dev → prod) — muito alinhado com a filosofia declarativa do curso.

Ainda em Stack Management você gere índices, Data Views, políticas (ILM — Módulo 08) e licenças.

## 6. Um passo além: alertas (visão geral)

O Kibana permite criar **alertas** (Rules) que observam os dados e disparam ações (e-mail, Slack, webhook) quando uma condição é atingida — ex.: "mais de 100 erros 5xx em 5 minutos". Não é o foco deste módulo, mas é o passo natural depois de ter dashboards: sair do *observar* para o *ser avisado*.

## 7. No laboratório

Você vai (a) confirmar/criar Data Views, (b) explorar os web logs no Discover com KQL, (c) construir 3 visualizações no Lens sobre o eCommerce, (d) montar um dashboard com um **control** de categoria, e (e) **exportar** os saved objects como `.ndjson`.

---

➡️ [**Laboratório**](laboratorio.md) · Dicas de KQL em [`exemplos/`](exemplos/) · [`slides.html`](slides.html)
