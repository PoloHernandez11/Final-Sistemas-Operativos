#!/usr/bin/env bash
# reporte.sh - Tarea 2: genera un informe del uso actual de CPU, memoria y disco,
# y lo guarda en un archivo log.
#
# Puede ejecutarse desde el menú principal o de forma independiente:
#   ./scripts/reporte.sh

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../config/config.conf
source "$BASE_DIR/config/config.conf"
# shellcheck source=lib.sh
source "$BASE_DIR/scripts/lib.sh"

mkdir -p "$LOG_DIR"
reporte_file="$LOG_DIR/reporte_recursos.log"

echo -e "${COLOR_CYAN}--- Reporte de uso de recursos ---${COLOR_RESET}"

fecha="$(date '+%Y-%m-%d %H:%M:%S')"

# CPU: porcentaje en uso (100 - % idle), obtenido de "top" en modo batch
cpu_uso="$(top -bn1 2>/dev/null | grep -i "Cpu(s)" | awk -F',' '{print $4}' | awk '{printf "%.1f", 100 - $1}')"
[[ -z "$cpu_uso" ]] && cpu_uso="N/D"

# Memoria: total, usada y porcentaje de uso
mem_info="$(free -m 2>/dev/null | awk '/Mem:/ {printf "%s MB usados de %s MB (%.1f%%)", $3, $2, ($3/$2)*100}')"
[[ -z "$mem_info" ]] && mem_info="N/D"

# Disco: uso del punto de montaje configurado
disco_info="$(df -h "$REPORTE_DISCO_PATH" 2>/dev/null | awk 'NR==2 {printf "%s usados de %s (%s)", $3, $2, $5}')"
[[ -z "$disco_info" ]] && disco_info="N/D"

{
    echo "===== Reporte de recursos - $fecha ====="
    echo "CPU en uso:               ${cpu_uso}%"
    echo "Memoria:                  $mem_info"
    echo "Disco ($REPORTE_DISCO_PATH):  $disco_info"
    echo
} | tee -a "$reporte_file"

echo -e "${COLOR_GREEN}Reporte guardado en: $reporte_file${COLOR_RESET}"
log_msg "INFO" "Reporte de recursos generado y guardado en $reporte_file"
