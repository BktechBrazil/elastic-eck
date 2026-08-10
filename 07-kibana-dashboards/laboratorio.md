# Laboratório 07 — Discover, Lens e Dashboards

> **Pré-requisito:** Módulo 02 com os Sample data. Kibana acessível (`port-forward` do `lab-kb`).
> **Tempo estimado:** 40–50 minutos. Este lab é **na interface do Kibana**.

```bash
kubectl -n elastic port-forward service/lab-kb-http 5601
# abra https://localhost:5601  (elastic / senha do Módulo 02)
```

---

## Parte A — Data Views e Discover

### Passo 1 — Confirmar os Data Views

Nesta etapa, você irá verificar se os Data Views gerados automaticamente pela carga de dados de exemplo (*Sample Data*) estão disponíveis no Kibana.

1. **Acessar o menu de gerenciamento:**
   No menu lateral esquerdo do Kibana, navegue até a seção de administração:
   **Management** → **Stack Management**.

   ![Página Inicial - Kibana](07-kibana-dashboards/prints%20treinamentos/pagina-inicial.png)

2. **Abrir a gestão de Data Views:**
   Dentro da tela do *Stack Management*, localize o menu lateral esquerdo e clique em **Data Views**.

   ![Data Views - Kibana](07-kibana-dashboards/prints%20treinamentos/kibana-data-views.png)

3. **Validar a presença dos itens:**
   Certifique-se de que os dois Data Views criados pelo conjunto de amostra estão visíveis na lista:
   * `kibana_sample_data_ecommerce` (Dados de vendas do e-commerce)
   * `kibana_sample_data_logs` (Logs de tráfego do servidor web)

> 💡 **Dica (Criação Manual):** Se no futuro precisar conectar um novo índice sem conjunto de dados pré-definido, clique em **Create data view**, insira o padrão do índice (ex: `filebeat-*`) e selecione o campo temporal correto (`order_date` para vendas ou `@timestamp` para eventos/logs).

### Passo 2 — Explorar os web logs

Abra **Discover**, selecione o Data View `kibana_sample_data_logs` e ajuste o tempo (canto superior direito) para "Last 7 days" (ou "Sample data" range). Aplique KQL:

```text
response.keyword : "404" and url : *login*
```

Adicione as colunas `url`, `response`, `geo.dest`. Você está **investigando** dados.

## Parte B — Lens: três visualizações do eCommerce

### Passo 3 — Receita por dia (linha)

**Menu → Visualize Library → Create → Lens**, Data View `...ecommerce`.
- Eixo X: `order_date` (Date histogram).
- Eixo Y: `Sum` de `taxful_total_price`.
- Tipo: **Line**. Salve como **"Receita por dia"**.

### Passo 4 — Receita por categoria (barras)

- Eixo X: `category.keyword` (Top values, tamanho 5).
- Eixo Y: `Sum` de `taxful_total_price`.
- Tipo: **Bar**. Salve como **"Receita por categoria"**.

### Passo 5 — Ticket médio (métrica/KPI)

- Métrica: `Average` de `taxful_total_price`.
- Tipo: **Metric**. Salve como **"Ticket médio"**.

## Parte C — Montar o dashboard

### Passo 6 — Criar e adicionar painéis

**Menu → Dashboard → Create dashboard → Add from library** e adicione as três visualizações. Organize/redimensione arrastando.

### Passo 7 — Adicionar um Control interativo

No topo do dashboard, **Controls → Add control → Options list**, campo `category.keyword`. Agora um menu no topo filtra **todos** os painéis por categoria.

### Passo 8 — Interatividade e tempo

Clique numa barra de categoria e veja o painel inteiro filtrar. Ajuste o intervalo de tempo global e observe todos responderem. Salve o dashboard como **"Visão de Vendas"**.

## Parte D — Gestão / versionamento

### Passo 9 — Exportar os Saved Objects

**Stack Management → Saved Objects** → selecione o dashboard "Visão de Vendas" → **Export** (marque "include related objects"). Você recebe um `.ndjson` — é o seu dashboard **versionável em Git** e portável entre ambientes.

---

## Desafios

1. Um **mapa** (Region map / Maps) com `sum(bytes)` por `geo.dest` nos web logs.
2. Um dashboard de **observabilidade** com os dados de `filebeat-*`/`metrics-system.*` do Módulo 06 (se ainda existirem).
3. Um **heatmap** de pedidos por dia da semana × hora.

---

## ✅ Você aprendeu

- Que tudo começa por um **Data View**.
- A **investigar** no Discover com **KQL**.
- A construir visualizações no **Lens** (bucket + metric).
- A montar **dashboards** interativos com **Controls** e a **exportar** saved objects para versionar.

➡️ **Módulo 08** — controlar o ciclo de vida dos índices com **ILM** e a topologia **hot-warm** no ECK.
