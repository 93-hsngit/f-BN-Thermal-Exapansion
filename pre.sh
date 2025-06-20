#!/bin/bash/

#phonopy -d --dim="2 2 1" -c POSCAR
phonopy -d --dim 5 5 1 --pa auto --amplitude 0.01 -c POSCAR

for file in POSCAR-*; do
        disp=$(echo "$file" | sed 's/POSCAR-\(.*\)/\1/')
        mkdir -p "disp-$disp"
done

for file in POSCAR-*; do
        disp=$(echo "$file" | sed 's/POSCAR-\(.*\)/\1/')
        cp "$file" "disp-$disp/POSCAR"
done

for folder in disp-*; do
        cp ../INCAR ../KPOINTS ../POTCAR "$folder"
        rm -rf POSCAR-*
done

