#!/bin/bash

# ================================
#  KiCad Schematic Diff Tool
# ================================

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <commit_old> <commit_new> <ruta_sch>"
    exit 1
fi

OLD=$1
NEW=$2
SCH=$3

OUTDIR="diff_output_sch"
mkdir -p "$OUTDIR"

command -v kicad-cli >/dev/null 2>&1 || { echo "Error: kicad-cli no está instalado."; exit 1; }
command -v compare >/dev/null 2>&1 || { echo "Error: 'compare' no está instalado (ImageMagick)."; exit 1; }

git show "$OLD:$SCH" >/dev/null 2>&1 || { echo "Error: $SCH no existe en $OLD"; exit 1; }
git show "$NEW:$SCH" >/dev/null 2>&1 || { echo "Error: $SCH no existe en $NEW"; exit 1; }

echo "Generando diff entre $OLD y $NEW para $SCH..."

git show "$OLD:$SCH" > "$OUTDIR/old.kicad_sch"
git show "$NEW:$SCH" > "$OUTDIR/new.kicad_sch"

kicad-cli sch export pdf "$OUTDIR/old.kicad_sch" --output "$OUTDIR/old.pdf"
kicad-cli sch export pdf "$OUTDIR/new.kicad_sch" --output "$OUTDIR/new.pdf"

compare "$OUTDIR/old.pdf" "$OUTDIR/new.pdf" "$OUTDIR/diff.png"

echo "Diff generado en: $OUTDIR"


