#!/bin/bash

# Define the scaling factors as an array (e.g., 0.95, 1.0, 1.05 for ±5% changes)
scaling_factors=(0.995 0.996 0.997 0.998 0.999 1.000 1.001 1.002 1.003 1.004 1.005 1.006 1.007 1.008)

# Read the original POSCAR file
original_poscar="POSCAR"
if [[ ! -f $original_poscar ]]; then
    echo "POSCAR file not found!"
    exit 1
fi

# Function to create a new POSCAR file with scaled lattice parameters
create_scaled_poscar() {
    scale=$1
    output_file=$2
    
    # Read the POSCAR file line by line
    lines=()
    while IFS= read -r line; do
        lines+=("$line")
    done < "$original_poscar"

    # Extract the original lattice vectors
    lattice_vector_a=(${lines[2]})
    lattice_vector_b=(${lines[3]})
    lattice_vector_c=(${lines[4]})

    # Scale the a and b lattice vectors
    lattice_vector_a_scaled=($(echo "${lattice_vector_a[@]}" | awk -v scale=$scale '{printf "%f %f %f\n", $1*scale, $2*scale, $3*scale}'))
    lattice_vector_b_scaled=($(echo "${lattice_vector_b[@]}" | awk -v scale=$scale '{printf "%f %f %f\n", $1*scale, $2*scale, $3*scale}'))

    # Write the new POSCAR file
    echo "${lines[0]}" > "$output_file"               # Comment line
    echo "${lines[1]}" >> "$output_file"              # Scaling factor
    echo "${lattice_vector_a_scaled[*]}" >> "$output_file"  # Scaled lattice vector a
    echo "${lattice_vector_b_scaled[*]}" >> "$output_file"  # Scaled lattice vector b
    echo "${lattice_vector_c[*]}" >> "$output_file"   # Unchanged lattice vector c

    # Append the rest of the POSCAR file (atom types, counts, coordinates)
    for ((i=5; i<${#lines[@]}; i++)); do
        echo "${lines[$i]}" >> "$output_file"
    done
}

# Generate scaled POSCAR files
for scale in "${scaling_factors[@]}"; do
    output_file="POSCAR_${scale}"
    create_scaled_poscar $scale $output_file
    echo "Generated $output_file with scaling factor $scale"
done

# Generate 10 different volume folder


for file in POSCAR_*; do
        vol=$(echo "$file" | sed 's/POSCAR_\(.*\)/\1/')
        mkdir -p "volume-$vol"
done

for file in POSCAR_*; do
        vol=$(echo "$file" | sed 's/POSCAR_\(.*\)/\1/')
        cp "$file" "volume-$vol/POSCAR"
done

rm POSCAR_*
