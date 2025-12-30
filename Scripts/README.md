📘 KiCad Diff Tools — README
Herramientas internas para generar diffs visuales de PCB y esquemáticos en KiCad 9

Este directorio contiene dos scripts diseñados para generar diffs visuales entre dos commits de Git en proyectos KiCad.
Son compatibles con KiCad 9, funcionan en Windows + Git Bash y están pensados para uso interno del equipo.

🧩 Contenido
kicad_diff.sh → Diff visual de PCB

kicad_diff_sch.sh → Diff visual de esquemáticos

diff_output_pcb/ → Resultados de diffs de PCB

diff_output_sch/ → Resultados de diffs de esquemáticos

kicad_warnings.log → Avisos de KiCad (opcional)

🛠 Requisitos
✔ KiCad 9
Debe estar instalado y accesible desde terminal:

bash
kicad-cli --version
✔ ImageMagick (con utilidades legacy)
Durante la instalación, activar:

[x] Add application directory to PATH

[x] Install legacy utilities (convert, compare)

Comprobar:

bash
compare --version
✔ Git Bash (Windows)
Los scripts están diseñados para ejecutarse desde Git Bash, no PowerShell.

🚀 Uso
1. Diff de PCB
bash
./Scripts/kicad_diff.sh <commit_old> <commit_new> <ruta_al_pcb>
Ejemplo real:

bash
./Scripts/kicad_diff.sh a1cdc48 ee58bff KiCad/BMS_MASTER_25_V0.0.kicad_pcb
Salida generada en:

Código
diff_output_pcb/
 ├── old.svg
 ├── new.svg
 └── diff.png
2. Diff de esquemáticos
bash
./Scripts/kicad_diff_sch.sh <commit_old> <commit_new> <ruta_al_sch>
Ejemplo:

bash
./Scripts/kicad_diff_sch.sh a1cdc48 ee58bff KiCad/BMS_MASTER_25_V0.0.kicad_sch
Salida generada en:

Código
diff_output_sch/
 ├── old.pdf
 ├── new.pdf
 └── diff.png
📂 Estructura recomendada del repositorio
Código
Scripts/
 ├── kicad_diff.sh
 ├── kicad_diff_sch.sh
 └── README.md
KiCad/
 ├── *.kicad_pcb
 ├── *.kicad_sch
 └── ...
🧪 Ejemplos útiles
Diff entre HEAD y el commit anterior
bash
./Scripts/kicad_diff.sh HEAD~1 HEAD KiCad/Placa.kicad_pcb
Diff entre ramas
bash
./Scripts/kicad_diff.sh main feature-x KiCad/Placa.kicad_pcb
Diff entre tags
bash
./Scripts/kicad_diff.sh v1.0 v1.1 KiCad/Placa.kicad_pcb
🛡 Manejo de errores
Los scripts detectan:

falta de dependencias

rutas incorrectas

archivos inexistentes en un commit

errores de exportación de KiCad

problemas con ImageMagick

Si algo falla, el script muestra un mensaje claro y se detiene.

📄 Notas sobre KiCad 9
KiCad 9 requiere especificar capas al exportar SVG.
Los scripts ya incluyen:

Código
F.Cu, B.Cu, F.SilkS, B.SilkS, Edge.Cuts
Si el equipo quiere añadir más capas, basta con editar la variable:

bash
LAYERS="..."
🧹 Logs limpios
Los avisos de KiCad (UTF‑8, Pango, etc.) se guardan en:

Código
diff_output_pcb/kicad_warnings.log
Esto evita ruido en la terminal.