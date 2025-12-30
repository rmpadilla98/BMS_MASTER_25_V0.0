#!/bin/bash

# --- KiCad PCB Diff Script ---
# Uso:
#   ./Scripts/kicad_diff.sh <commit_old> <commit_new> <ruta_pcb>
#
# Ejemplo:
#   ./Scripts/kicad_diff.sh HEAD~1 HEAD Hardware/Placa.kicad_pcb

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <commit_old> <commit_new> <ruta_pcb>"
    exit 1
fi

OLD=$1
NEW=$2
PCB=$3

OUTDIR="diff_output_pcb"
mkdir -p "$OUTDIR"

echo "Generando diff entre $OLD y $NEW para $PCB..."

# Exportar PCB antiguo
git show "$OLD:$PCB" > "$OUTDIR/old.kicad_pcb"

# Exportar PCB nuevo
git show "$NEW:$PCB" > "$OUTDIR/new.kicad_pcb"

# Convertir a SVG usando KiCad CLI
kicad-cli pcb export svg "$OUTDIR/old.kicad_pcb" --output "$OUTDIR/old.svg"
kicad-cli pcb export svg "$OUTDIR/new.kicad_pcb" --output "$OUTDIR/new.svg"

# Generar diff visual con ImageMagick
compare "$OUTDIR/old.svg" "$OUTDIR/new.svg" "$OUTDIR/diff.png"

echo "Diff generado en: $OUTDIR"
