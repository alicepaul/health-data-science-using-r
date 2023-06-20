# R for Health Data Science

The "R Book for Health Data Science" is a comprehensive guide designed to provide learners with the essential skills and knowledge needed to analyze health data using the R programming language. The book covers various modules, each focusing on specific topics and skills necessary for health data analysis. This book will cover topics in introduction in R, data structure, exploratory data analysis, data manipulation, data visualization, probability distribution, hypothesis testing and some regression analysis.

## Usage

### Building the book

If you'd like to develop and/or build the R for Health Data Science book, you should:

1. Clone this repository
2. Run `pip install -r requirements.txt` (it is recommended you do this within a virtual environment)
3. (Optional) Edit the books source files located in the `r-for-health-data-science/` directory
4. Run `jupyter-book clean r-for-health-data-science/` to remove any existing builds
5. Run `jupyter-book build r-for-health-data-science/`

A fully-rendered HTML version of the book will be built in `r-for-health-data-science/_build/html/`.

### Hosting the book

Please see the [Jupyter Book documentation](https://jupyterbook.org/publish/web.html) to discover options for deploying a book online using services such as GitHub, GitLab, or Netlify.

For GitHub and GitLab deployment specifically, the [cookiecutter-jupyter-book](https://github.com/executablebooks/cookiecutter-jupyter-book) includes templates for, and information about, optional continuous integration (CI) workflow files to help easily and automatically deploy books online with GitHub or GitLab. For example, if you chose `github` for the `include_ci` cookiecutter option, your book template was created with a GitHub actions workflow file that, once pushed to GitHub, automatically renders and pushes your book to the `gh-pages` branch of your repo and hosts it on GitHub Pages when a push or pull request is made to the main branch.

## Contributors

We welcome and recognize all contributions. You can see a list of current contributors in the [contributors tab](https://github.com/alicepaul/r-for-health-data-science/graphs/contributors).

## Credits

This project is created using the excellent open source [Jupyter Book project](https://jupyterbook.org/) and the [executablebooks/cookiecutter-jupyter-book template](https://github.com/executablebooks/cookiecutter-jupyter-book).

## Environment Version Information

- R_4.1.1
- tidyverse_1.3.1
- stats_4.1.1
- gt_0.9.0
- GGally_2.1.2
- ggcorrplot_0.1.4
- patchwork_1.1.2
- datasets_4.1.1
- haven_2.5.2
- RforHDSdata_0.1.0
