#!/usr/bin/env python3
import json
import sys
import re
import os

def process_notebook(ipynb_file):
    with open(ipynb_file, 'r', encoding='utf-8') as f:
        notebook = json.load(f) # load the notebook

    # def regex patterns
    crossref_pattern = re.compile(r'\?@sec-([a-zA-Z0-9_-]+)')


    # Process the notebook (fix chapter references)
    for cell in notebook.get('cells', []):
        if cell.get('cell_type') == 'markdown':
            
            source = ''.join(cell.get('source', []))
            
            matches = crossref_pattern.findall(source) # find all matches in the source
            
            for match in matches:
            
                # Replace with the mapped value (if it exists)
                replacement = mapping.get(match)
                if replacement:
                    source = source.replace(match, replacement)
                
                else:
                    print(f"Warning: No mapping found for {match} in {ipynb_file}")
                    
            # update the cell source
            cell['source'] = [source]
            
        elif cell.get('cell_type') == 'code':
            # No need to process code chunks (for now), so this is empty
            pass
            
# mapping dictionary for titles
mapping = {
    "intro-to-r": "1 Getting Started with R",
    "data-structures": "2 Data Structures in R",
    "data-files": "3 Working with Data Files in R",
    "exploratory": "4 Intro to Exploratory Data Analysis",
    "transformations-summaries": "5 Data Transformations and Summaries",
    "cs-preprocessing": "6 Case Study: Pre-Processing Data",
    "merging-reshaping": "7 Merging and Reshaping Data",
    "ggplot2": "8 Visualization with ggplot2",
    "cs-eda": "9 Case Study: Exploratory Data Analysis",
    "probability-distributions": "10 Probability Distributions in R",
    "hypothesis-testing": "11 Hypothesis Testing",
    "cs-testing": "12 Case Study: Hypothesis Testing",
    "linear-regression": "13 Linear Regression",
    "logistic-regression": "14 Logistic Regression",
    "model-selection": "15 Model Selection",
    "cs-regression": "16 Case Study: Regression",
    "control-flows": "17 Logic and Loops",
    "functions": "18 Functions",
    "cs-simulation": "19 Case Study: Designing a Simulation Study",
    "efficiency": "20 Writing Efficient Code",
    "expanding-skills": "21 Expanding your R Skills",
    "quarto": "22 Writing Reports in Quarto"
}

# verbose function
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: process_ipynb.py <notebook.ipynb>")
        sys.exit(1)

    ipynb_file = sys.argv[1]
    if not os.path.isfile(ipynb_file):
        print(f"File {ipynb_file} not found!")
        sys.exit(1)

    process_notebook(ipynb_file)
    