#!/bin/bash

# --- KiCad Schematic Diff Script ---
# Uso:
#   ./Scripts/kicad_diff_sch.sh <commit_old> <commit_new> <ruta_sch>

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <commit_old> <commit_new> <ruta_sch>"
    exit 1
fi

OLD=$1
NEW=$2
SCH=$3

OUTDIR="diff_output_sch"
mkdir -p "$OUTDIR"

echo "Generando diff entre $OLD y $NEW para $SCH..."

# Exportar esquemático antiguo
git show "$OLD:$SCH" > "$OUTDIR/old.kicad_sch"

# Exportar esquemático nuevo
git show "$NEW:$SCH" > "$OUTDIR/new.kicad_sch"

# Exportar a PDF usando KiCad CLI
kicad-cli sch export pdf "$OUTDIR/old.kicad_sch" --output "$OUTDIR/old.pdf"
kicad-cli sch export pdf "$OUTDIR/new.kicad_sch" --output "$OUTDIR/new.pdf"

# Generar diff visual con ImageMagick
compare "$OUTDIR/old.pdf" "$OUTDIR/new.pdf" "$OUTDIR/diff.png"

echo "Diff generado en: $OUTDIR"
