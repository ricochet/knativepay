#!/bin/bash

# Script to generate validator YAML files from a template

TEMPLATE_FILE="validator-template.yaml"
NUMBER_OF_VALIDATORS=100

# Ensure the generated directory exists
mkdir -p generated

echo "Generating validator YAML files..."

# Read the template file
TEMPLATE=$(cat "$TEMPLATE_FILE")

# Generate validator files
for i in $(seq 0 $((NUMBER_OF_VALIDATORS-1))); do
    # Replace ${UNIQUE_ID} with the current index
    CONTENT="${TEMPLATE//\$\{UNIQUE_ID\}/$i}"
    
    # Write to file
    echo "$CONTENT" > "generated/validator-$i.yaml"
done

echo "Generated $NUMBER_OF_VALIDATORS validator YAML files in the 'generated' directory."