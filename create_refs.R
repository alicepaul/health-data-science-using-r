
# generate a BibTeX database automatically for some R packages
knitr::write_bib(c(
  .packages(), 'tidyverse', 'gt', 'GGally', 'gtsummary', 'patchwork',
  'broom', 'car', 'pROC', 'HDSinRdata', 'kableExtra'
), 'packages.bib')


