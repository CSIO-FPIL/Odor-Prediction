#!/bin/bash

# Define a function to process each PDB file
process_pdb() {
    local pdb_file="$1"
    local base_name=$(basename "$pdb_file" .pdb)
    
    # Makes a directory with thename as the curent  PDB file
    mkdir -p "$base_name"

    # Read the PDB file
    lines=$(cat "$pdb_file")

    # Find the number of HETATM records
    a=$(grep HETATM "$pdb_file" | tail -1 | awk '{print $2}')

    # Write HETATM and CONECT records to temporary files within the directory
    grep HETATM "$pdb_file" > "$base_name/het"
    grep CONECT "$pdb_file" > "$base_name/con"

    # Generate new PDB files with different conformations within the directory
    for i in {101..1000}; do
        b=$((i * a))
        head -"$b" "$base_name/het" | tail -"$a" > "$base_name/${base_name}_conf_${i}.pdb"
        tail -"$a" "$base_name/con" >> "$base_name/${base_name}_conf_${i}.pdb"
    done
}

# Export the function to make it available to parallel
export -f process_pdb

# Get a list of PDB files in the current directory
pdb_files=$(ls *.pdb)

# Process PDB files in parallel
echo "$pdb_files" | parallel process_pdb
