# Trabajo Final - Sistemas Operativos

Script en Bash con menú interactivo que automatiza tres tareas de administración
de sistemas, desarrollado como Trabajo Final de la materia **Sistemas Operativos**
(Tecnicatura Superior en Desarrollo de Software - Instituto Superior IDRA).

## Descripción

El proyecto automatiza las siguientes tareas:

1. **Backup**: comprime un directorio en un archivo `.tar.gz` con marca de tiempo
   y elimina automáticamente los backups más antiguos que N días.
2. **Reporte de recursos**: genera un informe del uso actual de CPU, memoria y
   disco, y lo guarda en un archivo log.
3. **Limpieza de temporales**: elimina archivos temporales y de caché con más de
   N días de antigüedad para liberar espacio en disco.

Todas las tareas se ejecutan desde un menú interactivo (`menu.sh`) con colores y
mensajes claros, validación de las opciones ingresadas, y un registro de
actividad en `logs/actividad.log`.

## Requisitos

- Bash 4+ (Linux o macOS; en Windows puede usarse WSL o Git Bash)
- Utilidades estándar de GNU/Linux: `tar`, `du`, `df`, `free`, `top`, `find`,
  `xargs` (incluidas por defecto en la mayoría de las distribuciones)

## Estructura del proyecto

```
TrabajoFinalSO/
├── menu.sh                 # Menú principal
├── config/
│   └── config.conf         # Parámetros configurables (rutas, retención, etc.)
├── scripts/
│   ├── lib.sh               # Funciones y colores compartidos
│   ├── backup.sh            # Tarea 1: backup con rotación
│   ├── reporte.sh           # Tarea 2: reporte de CPU/memoria/disco
│   └── limpieza.sh          # Tarea 3: limpieza de temporales/caché
└── logs/                    # Logs generados en tiempo de ejecución
```

## Instrucciones de uso

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd TrabajoFinalSO
   ```
2. Dar permisos de ejecución (solo la primera vez):
   ```bash
   chmod +x menu.sh scripts/*.sh
   ```
3. Editar `config/config.conf` para ajustar rutas y parámetros a su entorno
   (directorio a respaldar, destino de backups, días de retención, etc.).
4. Ejecutar el menú principal:
   ```bash
   ./menu.sh
   ```
5. Seleccionar una opción del 1 al 4, o `0` para salir.

### Ejemplo

```
==================================================
   TRABAJO FINAL - SISTEMAS OPERATIVOS
   Script de automatización de tareas del sistema
==================================================

Seleccione una opción:
  1) Realizar backup de un directorio
  2) Generar reporte de uso de CPU, memoria y disco
  3) Limpiar archivos temporales y caché
  4) Ver log de actividad
  0) Salir

Ingrese una opción [0-4]: 1
```

Cada tarea también puede ejecutarse de forma independiente, por ejemplo:

```bash
./scripts/reporte.sh
```

## Cómo colaborar

1. Hacer un fork del repositorio.
2. Crear una rama para el cambio: `git checkout -b mi-mejora`.
3. Realizar los cambios y probarlos localmente.
4. Enviar un Pull Request describiendo el cambio propuesto.

Las sugerencias, reportes de errores y mejoras son bienvenidas a través de
Issues del repositorio.

## Licencia

Este proyecto se distribuye bajo la licencia [MIT](LICENSE).
