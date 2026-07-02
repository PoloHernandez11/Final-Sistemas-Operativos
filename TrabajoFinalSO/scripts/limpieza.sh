#!/usr/bin/env bash
# limpieza.sh - Tarea 3: elimina archivos temporales y de caché para liberar
# espacio en disco, sobre los directorios definidos en config/config.conf.
#
# Puede ejecutarse desde el menú principal o de forma independiente:
#   ./scripts/limpieza.sh

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../config/config.conf
source "$BASE_DIR/config/config.conf"
# shellcheck source=lib.sh
source "$BASE_DIR/scripts/lib.sh"

mkdir -p "$LOG_DIR"

echo -e "${COLOR_CYAN}--- Limpieza de archivos temporales y caché ---${COLOR_RESET}"
echo "Directorios configurados: ${TEMP_DIRS[*]}"
echo

read -rp "¿Confirma la eliminación de archivos con más de $TEMP_MIN_ANTIGUEDAD_DIAS día(s) de antigüedad? [s/N]: " confirmacion
if ! [[ "$confirmacion" =~ ^[sS]$ ]]; then
    echo -e "${COLOR_YELLOW}Operación cancelada por el usuario.${COLOR_RESET}"
    log_msg "INFO" "Limpieza de temporales cancelada por el usuario"
    exit 0
fi

espacio_liberado_total=0

for dir in "${TEMP_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo -e "${COLOR_YELLOW}Aviso: '$dir' no existe, se omite.${COLOR_RESET}"
        continue
    fi

    echo "Procesando: $dir"
    tamanio_antes=$(du -sk "$dir" 2>/dev/null | cut -f1)
    [[ -z "$tamanio_antes" ]] && tamanio_antes=0

    find "$dir" -type f -mtime "+$TEMP_MIN_ANTIGUEDAD_DIAS" -print0 2>/dev/null \
        | xargs -0 -r rm -f

    tamanio_despues=$(du -sk "$dir" 2>/dev/null | cut -f1)
    [[ -z "$tamanio_despues" ]] && tamanio_despues=0

    liberado=$((tamanio_antes - tamanio_despues))
    [[ "$liberado" -lt 0 ]] && liberado=0
    espacio_liberado_total=$((espacio_liberado_total + liberado))

    echo -e "${COLOR_GREEN}  Liberado en $dir: $((liberado / 1024)) MB${COLOR_RESET}"
    log_msg "INFO" "Limpieza en $dir: ${liberado} KB liberados"
done

echo
echo -e "${COLOR_GREEN}Limpieza finalizada. Espacio total liberado: $((espacio_liberado_total / 1024)) MB${COLOR_RESET}"
log_msg "INFO" "Limpieza de temporales finalizada: $((espacio_liberado_total / 1024)) MB liberados"
