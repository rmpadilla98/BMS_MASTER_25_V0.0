#!/bin/bash

# ============================================================
#   KiCad PCB Diff Tool (Compatible con KiCad 9)
#   Genera:
#     - old.svg
#     - new.svg
#     - diff.png
#     - combined.png (OLD | NEW | DIFF)
# ============================================================

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <commit_old> <commit_new> <ruta_pcb>"
    exit 1
fi

OLD=$1
NEW=$2
PCB=$3

OUTDIR="diff_output_pcb"
mkdir -p "$OUTDIR"

# ------------------------------
# Validación de dependencias
# ------------------------------
command -v kicad-cli >/dev/null 2>&1 || { echo "Error: kicad-cli no está instalado."; exit 1; }
command -v compare >/dev/null 2>&1 || { echo "Error: 'compare' no está instalado (ImageMagick)."; exit 1; }
command -v montage >/dev/null 2>&1 || { echo "Error: 'montage' no está instalado (ImageMagick)."; exit 1; }

# ------------------------------
# Validación de archivos en Git
# ------------------------------
git show "$OLD:$PCB" >/dev/null 2>&1 || { echo "Error: $PCB no existe en $OLD"; exit 1; }
git show "$NEW:$PCB" >/dev/null 2>&1 || { echo "Error: $PCB no existe en $NEW"; exit 1; }

echo "Generando diff entre $OLD y $NEW para $PCB..."

# ------------------------------
# Extraer archivos desde Git
# ------------------------------
git show "$OLD:$PCB" > "$OUTDIR/old.kicad_pcb"
git show "$NEW:$PCB" > "$OUTDIR/new.kicad_pcb"

# ------------------------------
# Exportar SVG (KiCad 9 requiere capas)
# ------------------------------
LAYERS="F.Cu,B.Cu,F.SilkS,B.SilkS,Edge.Cuts"

kicad-cli pcb export svg "$OUTDIR/old.kicad_pcb" \
  --layers $LAYERS \
  --output "$OUTDIR/old.svg" 2>>"$OUTDIR/kicad_warnings.log"

kicad-cli pcb export svg "$OUTDIR/new.kicad_pcb" \
  --layers $LAYERS \
  --output "$OUTDIR/new.svg" 2>>"$OUTDIR/kicad_warnings.log"

# ------------------------------
# Generar diff visual
# ------------------------------
compare "$OUTDIR/old.svg" "$OUTDIR/new.svg" "$OUTDIR/diff.png"

# ------------------------------
# Crear imagen compuesta OLD | NEW | DIFF
# ------------------------------
montage "$OUTDIR/old.svg" "$OUTDIR/new.svg" "$OUTDIR/diff.png" \
  -tile 3x1 -geometry +10+10 "$OUTDIR/combined.png"

# ------------------------------
# Versión con etiquetas (opcional)
# ------------------------------
montage \
  -label "OLD" "$OUTDIR/old.svg" \
  -label "NEW" "$OUTDIR/new.svg" \
  -label "DIFF" "$OUTDIR/diff.png" \
  -tile 3x1 -geometry +10+10 "$OUTDIR/combined_labeled.png"

echo "Diff generado en: $OUTDIR"



