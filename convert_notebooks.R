files <- list.files(path="./book", pattern = "*.ipynb")

for (f in files){
  input_path <- paste0("./book/", f)
  output_path <- paste0("./rmarkdown/", xfun::with_ext(f, "Rmd"))
  rmarkdown:::convert_ipynb(input_path, output_path)
}
