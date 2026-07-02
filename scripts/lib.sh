#!/usr/bin/env bash
# lib.sh - Funciones y colores compartidos por todos los scripts del proyecto.

COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_CYAN="\033[0;36m"

# log_msg NIVEL "mensaje" -> agrega una línea con fecha/hora a $LOG_DIR/actividad.log
log_msg() {
    local nivel="$1"
    local mensaje="$2"
    local fecha
    fecha="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$fecha] [$nivel] $mensaje" >> "$LOG_DIR/actividad.log"
}
