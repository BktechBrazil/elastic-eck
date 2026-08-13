# Módulo 12 — Elastic GenAI: Playground (RAG) e Agent Builder com LLM Local

> **Objetivo:** usar os recursos **nativos de GenAI** do Elastic — o **Playground** (RAG) e o **Agent Builder** (agentes de IA) — conectados a um **LLM local**, sem depender de nuvem nem de projetos externos. O Elastic atual já contempla a customização com LLMs locais, então **não** usamos o LocalAI: tudo passa pelo **conector compatível com a API OpenAI**.

> **Pré-requisito:** Módulos 02 e 07. **Módulo mais pesado do curso — leia a seção 6.**

---

## 1. O que é "GenAI no Elastic"

A ideia central é **RAG (Retrieval Augmented Generation)**: em vez de perguntar a um LLM "de cabeça" (que alucina e não conhece seus dados), você primeiro **recupera** os documentos relevantes no Elasticsearch e os **injeta** no prompt do LLM. O LLM responde **fundamentado nos seus dados**, com citações. O Elastic é o "cérebro de recuperação"; o LLM é o "redator".

O Elastic oferece dois recursos *built-in* no Kibana para isso:

**Playground** — uma interface para **conversar com os seus índices** via RAG. Você escolhe os índices, o Playground gera as queries de recuperação, injeta os resultados no LLM e devolve a resposta — e ainda mostra/deixa editar a query e baixar o código Python equivalente. Ótimo para prototipar rápido.

**Agent Builder** — a plataforma (GA nas versões recentes do Elastic) para criar **agentes de IA** que respondem **e agem** sobre os dados em linguagem natural. Um agente combina o LLM com **tools** (funções que buscam/manipulam dados no Elasticsearch), **skills** (conjuntos de instruções/conhecimento), uma **interface de chat**, integração **MCP** (importar/expor tools) e **workflows**. Nas versões recentes, o Agent Builder é a evolução GA do Playground de RAG.

## 2. O papel do LLM local (e por que é o caminho natural no ECK)

Todo esse fluxo precisa de um **LLM** para gerar o texto final. O Elastic conecta-se a provedores via **conectores**: OpenAI, Azure OpenAI, Amazon Bedrock, Google Gemini e — o que nos interessa — **LLMs locais compatíveis com a API OpenAI** (LM Studio, **Ollama**, vLLM), através do **conector OpenAI** apontando para o endpoint local.

Ponto importante do seu cenário: em um deployment **self-managed via ECK** **não existe** o "Elastic Managed LLM" (isso é oferta de Elastic Cloud/Serverless). Logo, o LLM é **sempre** configurado por conector — e rodar um **LLM local** (no próprio cluster ou numa VM ao lado) é o caminho natural, mantendo os dados e a inferência **dentro do seu ambiente**.

## 3. Como o RAG do Playground funciona (passo a passo)

1. Você seleciona um ou mais **índices** com os documentos.
2. Ao perguntar, o Playground monta uma **query de recuperação** (texto, semântica com embeddings, ou híbrida) e traz os trechos mais relevantes.
3. Esses trechos entram no **prompt** junto com uma instrução de sistema ("responda apenas com base no contexto…").
4. O **LLM (local)** gera a resposta; o Playground exibe com as fontes.

Para recuperação **semântica**, o Elastic usa o tipo de campo **`semantic_text`** e o serviço de **inference** (embeddings) — que pode inclusive rodar com o modelo `ELSER` da Elastic ou embeddings de terceiros. Para o lab, começamos com recuperação **textual** (mais leve) e citamos a semântica como evolução.

## 4. Agentes no Agent Builder

Um agente recebe uma pergunta em linguagem natural e **decide** quais **tools** usar para respondê-la — por exemplo, uma tool de busca no índice de produtos, outra que consulta pedidos. Ele orquestra as chamadas, junta os resultados e redige a resposta com o LLM. É o salto de "buscar" para "raciocinar sobre os dados e agir".

## 5. Licença

Playground e Agent Builder, além de recursos de inference/semantic, geralmente exigem uma licença acima de Basic. Ative o **trial de 30 dias** (Módulo 09) para ter tudo liberado no laboratório. O **conector** em si (OpenAI/local) é configurado em **Stack Management → Connectors**.

## 6. Recursos no lab de 16 GB — leia antes

Este é, junto com o Módulo 09, o **mais pesado**. Rodar um LLM local **compete** por RAM/CPU com o Elasticsearch e o Kibana. Recomendações:

- **Modelo pequeno** (ex.: `llama3.2:1b` ou `qwen2.5:0.5b` no Ollama) — nada de 7B+ em 16 GB.
- **Suba o LLM sob demanda** e **derrube** os coletores/outros clusters antes.
- Idealmente **aumente a VM para 32 GB** para este módulo.
- O LLM pode rodar **no próprio cluster** (manifesto `ollama.yaml` deste módulo) ou **fora** (LM Studio/Ollama na VM host, apontando o conector para o IP do host).

## 7. No laboratório

Você vai (a) subir um **LLM local** (Ollama com modelo pequeno) — no cluster ou na VM, (b) ativar o **trial** e criar o **conector OpenAI** apontando para o LLM local, (c) indexar alguns documentos e usar o **Playground** para conversar com eles via RAG, e (d) criar um **agente** simples no **Agent Builder** com uma tool de busca.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
