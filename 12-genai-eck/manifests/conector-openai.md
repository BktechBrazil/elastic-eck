# Conector OpenAI apontando para o LLM local (Módulo 12)

O Elastic conecta-se ao LLM local pelo **conector OpenAI** (compatível com a API OpenAI).
Crie-o pela UI ou pela API do Kibana.

## Opção 1 — Kibana UI
**Stack Management → Connectors → Create connector → OpenAI** e preencha:

- **Connector name:** `llm-local`
- **OpenAI provider:** `OpenAI` (compatível)
- **URL:** `http://ollama.elastic.svc:11434/v1/chat/completions`
  - Se o Ollama/LM Studio rodar na VM host (fora do cluster), use `http://<IP-do-host>:11434/v1/chat/completions`.
- **Default model:** `llama3.2:1b` (ou o modelo que você baixou)
- **API key:** qualquer valor não-vazio (Ollama ignora, mas o campo é obrigatório) — ex.: `ollama`

## Opção 2 — API do Kibana (Dev Tools ou curl)
```
POST kbn:/api/actions/connector
{
  "name": "llm-local",
  "connector_type_id": ".gen-ai",
  "config": {
    "apiProvider": "OpenAI",
    "apiUrl": "http://ollama.elastic.svc:11434/v1/chat/completions",
    "defaultModel": "llama3.2:1b"
  },
  "secrets": { "apiKey": "ollama" }
}
```

> Após criar, o conector `llm-local` fica disponível para o **Playground** e o **Agent Builder**
> escolherem como modelo de geração.
