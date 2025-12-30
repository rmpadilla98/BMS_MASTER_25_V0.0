#!/bin/bash

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

git show "$OLD:$PCB" > "$OUTDIR/old.kicad_pcb"
git show "$NEW:$PCB" > "$OUTDIR/new.kicad_pcb"

# Exportar a SVG indicando capas (KiCad 9 requiere esto)
LAYERS="F.Cu,B.Cu,F.SilkS,B.SilkS,Edge.Cuts"

kicad-cli pcb export svg "$OUTDIR/old.kicad_pcb" \
  --layers $LAYERS \
  --output "$OUTDIR/old.svg"

kicad-cli pcb export svg "$OUTDIR/new.kicad_pcb" \
  --layers $LAYERS \
  --output "$OUTDIR/new.svg"

# Generar diff visual
compare "$OUTDIR/old.svg" "$OUTDIR/new.svg" "$OUTDIR/diff.png"

echo "Diff generado en: $OUTDIR"

