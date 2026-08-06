# Módulo 10 — Migração e Atualização de Versão (Upgrade) no ECK

> **Objetivo:** atualizar o Elastic Stack (Elasticsearch e Kibana) **sem downtime**, deixando o **operator** orquestrar o *rolling upgrade*. Entender a ordem correta, os cuidados prévios (deprecations, snapshots) e como atualizar o **próprio operator**.

> **Pré-requisito:** Módulo 02 (`lab-es` + `lab-kb`). No curso original, este módulo era a "atualização de versão do Kibana"; no ECK ele vira um *upgrade* declarativo de todo o Stack.

---

## 1. A grande diferença: upgrade é declarativo

No mundo tradicional, atualizar o Elasticsearch é um procedimento manual e tenso: parar nó, trocar pacote, subir, esperar realocar, repetir para cada nó, na ordem certa, torcendo para nada quebrar. No ECK, você **muda um campo** — `spec.version` — e aplica. O operator faz o resto: um **rolling upgrade** ordenado, atualizando os pods **um a um**, respeitando a saúde do cluster (não derruba o próximo nó enquanto o cluster não estiver estável) e a alocação de shards.

```yaml
spec:
  version: 9.4.2   ->   9.4.4
```

`kubectl apply` e pronto — o operator reconcilia.

## 2. A ordem importa

Componentes do Stack têm regras de compatibilidade. A ordem segura de upgrade é:

1. **Operator ECK** primeiro (se a nova versão do Stack exigir um operator mais novo).
2. **Elasticsearch** antes do **Kibana**. O Kibana **não** pode ser mais novo que o Elasticsearch a que se conecta; o ES tolera um Kibana de versão anterior durante a janela de upgrade.
3. Demais componentes (Beats/Agent, Logstash, APM) depois.

Além disso, respeite os **saltos de versão suportados**: upgrades de *patch* e *minor* (ex.: 9.4.2 → 9.4.4, ou 9.3 → 9.4) são diretos; saltos de *major* (ex.: 8.x → 9.x) têm pré-requisitos e devem passar pela última minor da major anterior.

## 3. Antes de apertar o botão: cuidados

**Snapshot.** Sempre tenha um **snapshot** recente antes de um upgrade — é a sua rede de segurança para reverter. Snapshots vão para um *repository* (object storage como S3/GCS em produção; no lab, um repositório de sistema de arquivos).

**Upgrade Assistant / Deprecations.** O Kibana traz o **Upgrade Assistant** (Stack Management), que lista **deprecations**: configurações e índices que precisam de ajuste antes do próximo major. Para minors/patches costuma estar limpo; antes de um major, é obrigatório resolver os itens críticos.

**Ler as release notes / breaking changes** da versão-alvo.

## 4. Como o operator conduz o rolling upgrade

Ao detectar a mudança de `version`, o operator:

1. Baixa a nova imagem e cria pods novos (ou recria em ordem), **um `nodeSet`/pod por vez**.
2. Antes de derrubar um nó de dados, coordena para o cluster não ficar sem shards (respeita `green`/`yellow` conforme configuração).
3. Aguarda o pod novo entrar e o cluster estabilizar antes de seguir para o próximo.

Você **acompanha**, não executa. Em single-node há uma breve indisponibilidade (só há um nó para reiniciar) — em produção multi-nó o serviço permanece no ar.

## 5. Atualizando o próprio operator (Helm)

O operator instalado no Módulo 01 via Helm é atualizado com um `helm upgrade`:

```bash
helm repo update
helm upgrade elastic-operator elastic/eck-operator -n elastic-system --version <nova>
```

Atualizar o operator **não** atualiza seus clusters ES/Kibana — ele apenas passa a suportar versões mais novas e traz correções. Os clusters só sobem de versão quando você muda o `spec.version` deles.

## 6. No laboratório

Você vai (a) conferir o **Upgrade Assistant** (deprecations), (b) fazer um **snapshot** num repositório de filesystem, (c) subir o **Elasticsearch** de `9.4.2` para `9.4.4` mudando o CRD e acompanhar o rolling upgrade, (d) subir o **Kibana** na sequência, e (e) validar as versões. (Opcional) `helm upgrade` do operator.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
