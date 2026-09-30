# uptime-alert-slack

Monitor de disponibilidade de sites em Bash: verifica cada URL, tenta de novo antes de declarar falha e avisa no Slack quando o site realmente caiu. Containerizado, com pipeline de CI no GitHub Actions.

## O problema que resolve

Checar manualmente se um site está no ar é lento e não escala: alguém precisa lembrar, abrir o navegador e conferir cada URL. Pior, uma falha passageira gera falso alarme. Este projeto automatiza a checagem, confirma a falha com retry e manda o alerta direto no canal do time.

## Como funciona

1. Para cada URL da lista, o script faz uma requisição com `curl` e lê o código HTTP.
2. Se não for 200, tenta novamente (até 3 tentativas, com pausa de 2s entre elas).
3. Se todas falharem, registra o alerta no log e envia mensagem ao Slack via webhook.
4. Se a variável `SLACK_WEBHOOK_URL` não estiver definida, o script só registra em log e não quebra.

## Stack

- **Bash + curl**: verificação HTTP (`health_check.sh`)
- **Docker**: containeriza o script
- **Docker Compose**: sobe Prometheus e Grafana (ver Roadmap)
- **GitHub Actions**: builda a imagem a cada push na `main`

## Como rodar

```bash
git clone https://github.com/antoniomanol62-ux/uptime-alert-slack.git
cd uptime-alert-slack

# opcional: habilita o alerta no Slack
export SLACK_WEBHOOK_URL="sua-url-de-webhook"

./health_check.sh
```

Para alterar os sites monitorados, edite o array `SERVICOS` no início do `health_check.sh`. O log é gravado em `$HOME/health_check.log`.

> A URL do webhook é uma credencial: nunca a coloque no código nem faça commit dela.

## Estrutura

- `health_check.sh`: checagem HTTP, retry e alerta no Slack
- `Dockerfile`: containeriza o script
- `docker-compose.yml`: sobe Prometheus e Grafana com restart automático
- `.github/workflows/`: pipeline de CI

## Roadmap

- [ ] Rodar o health check como serviço no Compose, em loop contínuo
- [ ] Ler a URL do webhook de um `.env` (com `.env.example`)
- [ ] Persistir o log em volume
- [ ] Mover a lista de sites para um arquivo de configuração
- [ ] Expor métricas para o Prometheus e montar um dashboard no Grafana
- [ ] Tratar redirects (`curl -L`) e definir timeout (`--max-time`)

## Sobre o projeto

Construído como prática de DevOps: containerização, automação de pipeline e alertas, evoluindo uma peça de cada vez.
