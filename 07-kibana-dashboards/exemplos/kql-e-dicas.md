# KQL e dicas para Discover/Dashboards

## KQL (Kibana Query Language) — exemplos

```text
# igualdade em keyword
customer_gender : "FEMALE"

# numérico e combinação lógica
taxful_total_price > 50 and taxful_total_price <= 100

# curinga em texto
category : *Clothing*

# OR e negação
response.keyword : "404" or response.keyword : "500"
not machine.os : "ios"

# campo existe
url : *

# aninhado / intervalo de datas usa o seletor de tempo do topo (não em KQL)
geo.dest : "US" and bytes > 5000
```

## Dicas de Lens
- Comece pela **pergunta**; arraste o campo de data para o eixo X e a métrica (ex.: `sum(taxful_total_price)`) para o Y.
- Troque o tipo de gráfico no seletor à direita sem perder a configuração.
- Use **"Break down by"** para quebrar uma série por categoria (vira múltiplas linhas/barras).
- Formate valores (moeda, %) no painel do campo → *Value format*.

## Dicas de Dashboard
- Adicione **Controls** (topo → "Controls") do tipo *Options list* em `category.keyword` para filtrar interativamente.
- Fixe o **intervalo de tempo** e salve com "Store time with dashboard" quando quiser um período padrão.
- Clique numa fatia/barra para **filtrar** o painel inteiro; remova o filtro na barra superior.

## Exportar/Importar (versionar em Git)
- **Stack Management → Saved Objects → Export** (selecione o dashboard; inclua objetos relacionados) → arquivo `.ndjson`.
- Para promover a outro ambiente: **Import** o `.ndjson`.
