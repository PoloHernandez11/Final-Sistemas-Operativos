#!/usr/bin/env bash
#
# menu.sh - Menú principal del Trabajo Final de Sistemas Operativos
# Instituto Superior IDRA - Tecnicatura Superior en Desarrollo de Software
#
# Automatiza tres tareas administrativas del sistema:
#   1) Backup de un directorio con rotación de backups antiguos.
#   2) Reporte de uso de CPU, memoria y disco.
#   3) Limpieza de archivos temporales y caché.
#
# Uso: ./menu.sh

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=config/config.conf
source "$BASE_DIR/config/config.conf"
# shellcheck source=scripts/lib.sh
source "$BASE_DIR/scripts/lib.sh"

mkdir -p "$LOG_DIR"

mostrar_banner() {
    clear
    echo -e "${COLOR_CYAN}==================================================${COLOR_RESET}"
    echo -e "${COLOR_CYAN}   TRABAJO FINAL - SISTEMAS OPERATIVOS${COLOR_RESET}"
    echo -e "${COLOR_CYAN}   Script de automatización de tareas del sistema${COLOR_RESET}"
    echo -e "${COLOR_CYAN}==================================================${COLOR_RESET}"
    echo
}

mostrar_menu() {
    echo -e "${COLOR_YELLOW}Seleccione una opción:${COLOR_RESET}"
    echo -e "  ${COLOR_GREEN}1)${COLOR_RESET} Realizar backup de un directorio"
    echo -e "  ${COLOR_GREEN}2)${COLOR_RESET} Generar reporte de uso de CPU, memoria y disco"
    echo -e "  ${COLOR_GREEN}3)${COLOR_RESET} Limpiar archivos temporales y caché"
    echo -e "  ${COLOR_GREEN}4)${COLOR_RESET} Ver log de actividad"
    echo -e "  ${COLOR_RED}0)${COLOR_RESET} Salir"
    echo
}

pausar() {
    echo
    read -rp "Presione ENTER para continuar..." _
}

while true; do
    mostrar_banner
    mostrar_menu
    read -rp "Ingrese una opción [0-4]: " opcion

    # Validación de entrada: solo se aceptan números del 0 al 4
    if ! [[ "$opcion" =~ ^[0-4]$ ]]; then
        log_msg "WARN" "Opción inválida ingresada: '$opcion'"
        echo -e "${COLOR_RED}Opción inválida. Ingrese un número entre 0 y 4.${COLOR_RESET}"
        pausar
        continue
    fi

    case "$opcion" in
        1)
            log_msg "INFO" "Usuario seleccionó: Backup"
            bash "$BASE_DIR/scripts/backup.sh"
            pausar
            ;;
        2)
            log_msg "INFO" "Usuario seleccionó: Reporte de recursos"
            bash "$BASE_DIR/scripts/reporte.sh"
            pausar
            ;;
        3)
            log_msg "INFO" "Usuario seleccionó: Limpieza de temporales"
            bash "$BASE_DIR/scripts/limpieza.sh"
            pausar
            ;;
        4)
            echo -e "${COLOR_CYAN}--- Últimas 20 líneas del log de actividad ---${COLOR_RESET}"
            tail -n 20 "$LOG_DIR/actividad.log" 2>/dev/null || echo "El log aún no tiene registros."
            pausar
            ;;
        0)
            echo -e "${COLOR_GREEN}Saliendo... ¡Hasta luego!${COLOR_RESET}"
            log_msg "INFO" "Script finalizado por el usuario"
            exit 0
            ;;
    esac
done
