#!/usr/bin/env bash
# backup.sh - Tarea 1: respalda un directorio en un archivo .tar.gz
# y elimina automáticamente los backups más antiguos que BACKUP_RETENTION_DAYS.
#
# Puede ejecutarse desde el menú principal o de forma independiente:
#   ./scripts/backup.sh

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../config/config.conf
source "$BASE_DIR/config/config.conf"
# shellcheck source=lib.sh
source "$BASE_DIR/scripts/lib.sh"

mkdir -p "$LOG_DIR"

echo -e "${COLOR_CYAN}--- Backup de directorio ---${COLOR_RESET}"

if [[ ! -d "$BACKUP_SOURCE_DIR" ]]; then
    echo -e "${COLOR_RED}Error: el directorio origen '$BACKUP_SOURCE_DIR' no existe.${COLOR_RESET}"
    echo "Puede modificarlo en config/config.conf (BACKUP_SOURCE_DIR)."
    log_msg "ERROR" "Backup fallido: no existe el directorio origen $BACKUP_SOURCE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_DEST_DIR"

timestamp="$(date '+%Y%m%d_%H%M%S')"
nombre_base="$(basename "$BACKUP_SOURCE_DIR")"
archivo_backup="$BACKUP_DEST_DIR/${nombre_base}_${timestamp}.tar.gz"

echo "Origen:  $BACKUP_SOURCE_DIR"
echo "Destino: $archivo_backup"
echo

if tar -czf "$archivo_backup" -C "$(dirname "$BACKUP_SOURCE_DIR")" "$nombre_base" 2>/dev/null; then
    tamanio="$(du -h "$archivo_backup" | cut -f1)"
    echo -e "${COLOR_GREEN}Backup creado correctamente (${tamanio}).${COLOR_RESET}"
    log_msg "INFO" "Backup creado: $archivo_backup ($tamanio)"
else
    echo -e "${COLOR_RED}Error al crear el backup.${COLOR_RESET}"
    log_msg "ERROR" "Fallo al crear el backup de $BACKUP_SOURCE_DIR"
    exit 1
fi

echo
echo "Buscando backups con más de $BACKUP_RETENTION_DAYS día(s) de antigüedad..."

eliminados=0
while IFS= read -r -d '' viejo; do
    rm -f "$viejo"
    echo -e "${COLOR_YELLOW}Eliminado: $viejo${COLOR_RESET}"
    log_msg "INFO" "Backup antiguo eliminado: $viejo"
    eliminados=$((eliminados + 1))
done < <(find "$BACKUP_DEST_DIR" -maxdepth 1 -name "*.tar.gz" -mtime "+$BACKUP_RETENTION_DAYS" -print0)

if [[ "$eliminados" -eq 0 ]]; then
    echo "No se encontraron backups antiguos para eliminar."
fi

echo -e "${COLOR_GREEN}Proceso de backup finalizado.${COLOR_RESET}"
