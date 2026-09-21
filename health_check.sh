#!/bin/bash

SERVICOS=(
  "https://www.brisanet.com.br"
  "https://grupo.brisanet.com.br"
)

LOG="/var/log/health_check.log"
DATA=$(date "+%Y-%m-%d %H:%M:%S")

for url in "${SERVICOS[@]}"
do
  codigo=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [ "$codigo" -eq 200 ]; then
    echo "$DATA - OK: $url respondendo (codigo $codigo)" | tee -a "$LOG"
  else
    echo "$DATA - ALERTA: $url com problema! (codigo $codigo)" | tee -a "$LOG"
  fi
done
