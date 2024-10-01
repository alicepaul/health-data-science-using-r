# Remove existing files
rm *.ipynb
rm -r images
rm -r data

# Copy over notebooks, images, and data
cp -R ../book/images .
cp -R ../book/data .
cp -r ../book/*qmd .

# Convert to jupyter notebook
for filename in *.qmd; 
do 
    echo "${filename}"
    jupyter_name=$(basename -- "$filename" .qmd)
    cat jupyter_header.txt >> $filename; 
    quarto convert $filename 
    sed -i '_temp.ipynb' '/:::/,/:::/d' $jupyter_name.ipynb
done

rm *_temp.ipynb
rm *.qmd
