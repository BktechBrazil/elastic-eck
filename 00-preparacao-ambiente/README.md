# Módulo 00 — Preparação de Ambiente

> **Objetivo:** deixar a VM pronta para receber um cluster Kubernetes e o Elastic Stack. Ao final deste módulo, o sistema operacional estará com kernel, rede e runtime de containers configurados — sem ainda instalar o Kubernetes (isso é o Módulo 01).

---

## 1. Por que preparar o host antes?

Kubernetes e Elasticsearch fazem exigências específicas ao sistema operacional. Se você pular esta etapa, os sintomas aparecem lá na frente e são confusos: o kubelet se recusa a subir porque o **swap** está ligado, o pod do Elasticsearch entra em *crash loop* porque o **`vm.max_map_count`** está baixo, ou os pods não conseguem se comunicar porque faltam **módulos de kernel de rede**. Preparar o host primeiro elimina 90% dos problemas de laboratório.

Pense nesta camada como o "alicerce": o Kubernetes é a estrutura, o Elastic é o prédio, mas nada disso fica de pé sem o terreno nivelado.

## 2. A VM do laboratório

| Recurso | Valor | Por quê |
|---|---|---|
| vCPU | 8 | Control plane + Elasticsearch + Kibana + ingestão com folga |
| RAM | 16 GB | Piso recomendado; ES usa 4 GB, sobra para o resto |
| Disco | 100 GB | Imagens de container + PVCs (dados do ES) + datasets |
| SO | Ubuntu Server LTS 22.04/24.04 | Mais comum e melhor documentado para kubeadm |

> Este curso usa **um único nó** que acumula os papéis de *control plane* e *worker*. Em produção você separaria esses papéis, mas para aprender o comportamento do Elastic isso é irrelevante e economiza recursos.

## 3. O que vamos configurar (e o que cada coisa faz)

**a) Atualização e utilitários.** Sistema em dia e ferramentas básicas (`curl`, `gnupg`, `apt-transport-https`) para adicionar repositórios com segurança.

**b) Desligar o swap.** O kubelet exige swap desativado por padrão. O agendador do Kubernetes toma decisões com base na memória real disponível; o swap "esconde" pressão de memória e atrapalha essas decisões. Por isso desligamos.

**c) Módulos de kernel `overlay` e `br_netfilter`.**
- `overlay` é o sistema de arquivos usado pelos containers (camadas de imagem).
- `br_netfilter` faz o tráfego que passa por *bridges* de rede Linux ser visível ao `iptables`, o que a rede de pods (CNI) precisa para aplicar regras.

**d) Parâmetros de rede (`sysctl`).**
- `net.ipv4.ip_forward=1` permite o roteamento de pacotes entre pods/nós.
- `net.bridge.bridge-nf-call-iptables=1` (e a versão ip6) garantem que o `iptables` processe o tráfego em bridge.

**e) `vm.max_map_count=1048576`.** Esta é a exigência do **Elasticsearch**. O ES usa *memory-mapped files* para acessar índices com eficiência, e cada segmento consome "áreas de mapeamento de memória". O padrão do Linux (65530) é baixíssimo para o ES 8.16+/9.x, que pede **1048576**. Como nosso lab é **uma VM só**, setamos isso **direto no host** — assim todos os pods do ES herdam o valor e **não precisamos de initContainers privilegiados** (que seriam necessários em clusters gerenciados onde não temos acesso ao nó).

**f) Runtime de containers (containerd).** O Kubernetes não roda containers sozinho; ele delega a um *container runtime*. Usamos o **containerd**, o mesmo runtime enxuto que o Docker usa por baixo. Configuramos o `containerd` para usar `SystemdCgroup=true`, alinhando-o ao gerenciador de cgroups do Ubuntu (systemd) — desalinhar isso causa instabilidade do kubelet.

## 4. Resultado esperado

Ao final do [laboratório](laboratorio.md):
- `free -h` mostra **swap zerado**.
- `sysctl vm.max_map_count` retorna **1048576**.
- `lsmod | grep br_netfilter` mostra o módulo carregado.
- `systemctl status containerd` mostra o serviço **ativo**.

Com isso, o terreno está nivelado para o **Módulo 01 — Instalação do Kubernetes**.

---

➡️ Faça agora o [**laboratório**](laboratorio.md) · Slides: [`slides.html`](slides.html)
