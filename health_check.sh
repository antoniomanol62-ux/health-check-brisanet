#!/bin/bash

SERVICOS=(${SITES:-https://example.com})

LOG="${LOG_FILE:-$HOME/health_check.log}"
TENTATIVAS=3

for url in "${SERVICOS[@]}"
do
  sucesso=0

  for tentativa in $(seq 1 $TENTATIVAS)
  do
    codigo=$(curl -s -L --max-time 10 -o /dev/null -w "%{http_code}" "$url")
    DATA=$(date "+%Y-%m-%d %H:%M:%S")

    if [ "$codigo" -eq 200 ]; then
      echo "$DATA - OK: $url respondendo (codigo $codigo)" | tee -a "$LOG"
      sucesso=1
      break
    else
      echo "$DATA - Tentativa $tentativa falhou para $url (codigo $codigo)" | tee -a "$LOG"
      sleep 2
    fi
  done

  if [ "$sucesso" -eq 0 ]; then
    echo "$DATA - ALERTA: $url com problema apos $TENTATIVAS tentativas! (codigo $codigo)" | tee -a "$LOG"
    if [ -n "$SLACK_WEBHOOK_URL" ]; then
      MENSAGEM="{\"text\":\"ALERTA: $url fora do ar! Codigo: $codigo\"}"
      curl -s -X POST -H 'Content-type: application/json' --data "$MENSAGEM" "$SLACK_WEBHOOK_URL"
    fi
  fi
done
