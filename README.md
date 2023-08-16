# Health Data Science in R

The "Health Data Science in R" is a comprehensive guide designed to provide learners with the essential skills and knowledge needed to analyze health data using the R programming language. This book covers data structures in R, exploratory data analysis, data manipulation, data visualization, probability distributions, hypothesis testing, and regression analysis. Prior knowledge with the statistical methodology underlying the analysis is assumed. 

## License

This work is licensed under the Creative Commons Attribution 4.0 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) United States License. 

## Contributors

This book is written by [Alice Paul](alicepaul.github.io) with the support of Jialin Liu, Joanna Walsh, and Xinbei Yu. Please contact Alice Paul (alice_paul@brown.edu) with questions.

## Credits

This project is created using the [Jupyter Book project](https://jupyterbook.org/) and the [executablebooks/cookiecutter-jupyter-book template](https://github.com/executablebooks/cookiecutter-jupyter-book).

## Environment Version Information

- R_4.2.3
- tidyverse_1.3.2
- gt_0.9.0
- GGally_2.1.2
- patchwork_1.1.2
- broom_1.0.5
- pROC_1.18.2
- car_3.1
- HDSinRdata_0.1.0
- gtsummary_1.7.1
- kableExtra_1.3.4

- [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/alicepaul/health-data-science-in-r/main)

## Guideline for this repository

In this github repo, you can find jupyter notebook version of each chapter inside `book` folder along with the corresponding R markdown file in the `rmarkdown` folder. Most of data used in the examples is provided in the library `RforHDSdata`, but there are two toy datasets stored in the `data` folder inside `book` folder. You can find the dockerfile inside `binder` folder. The `workflow` binder contains two files for deployment and building the notebook container. All the required packages and version information can be found in the `environment.yml` file, and it is also available in this `README` file.
