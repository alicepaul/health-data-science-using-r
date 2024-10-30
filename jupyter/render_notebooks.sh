#!/bin/bash

# rm existing files
rm *.ipynb
rm -r images
rm -r data

# copy qmd notebooks, images, data from books folder
cp -R ../book/images .
cp -R ../book/data .
cp -r ../book/*qmd .
rm quarto_reports.qmd

# Render .qmd files to ipynb notebooks
for filename in *.qmd; 
do 
    echo "Rendering ${filename} to ipynb"
    jupyter_name=$(basename -- "$filename" .qmd)
    
    # Render to ipynb
    quarto render "$filename" --to ipynb --profile advanced
    
    # Post-process ipynb file (chapter references)
    ipynb_file="${jupyter_name}.ipynb"
    
    if [ -f "$ipynb_file" ]; then
        echo "Post-processing ${ipynb_file}"
        
        python3 process_ipynb.py "$ipynb_file" # call cleaning script
        
    else
        echo "File ${ipynb_file} not found!"
    fi
done

# rm quarto files
rm *.qmd