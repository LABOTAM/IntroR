##################
## Compila o livro
##################
bookdown::serve_book(
  dir = ".",
  output_dir = "docs",
  in_session = FALSE
)


# Gitbook
bookdown::render_book(
  input = 'index.Rmd',
  output_format = 'bookdown::gitbook')
# Pdf
bookdown::render_book(
  input = 'index.Rmd',
  output_format = 'bookdown::pdf_book',
  encoding = 'UTF-8',
  config_file = "_bookdown.yml")
rmarkdown::render(
  input = 'index.Rmd',
  output_format = 'bookdown::pdf_book',
  encoding = 'UTF-8',
  output_file = "VicentiniPerdiz2021_IntroR.pdf",
  output_dir = "_book/",
  clean = TRUE
)

# Epub
bookdown::render_book(
  input = 'index.Rmd',
  output_format = 'bookdown::epub_book'
  )
##################
## Pre-visualiza um capitulo
##################
bookdown::preview_chapter(
  input = "suplemento-tidyverse.Rmd",
  output_file = "preview.html",
  output_format = "html_document",
  output_dir = "./previsualizacao_capitulos",

)

bookdown::preview_chapter(
  input = "cap02_matrizes-dframes.Rmd",
  output_format = "html_document",
  output_dir = "previsualizacao_capitulos"
)

# README
rmarkdown::render("README.Rmd", output_format = "md_document", encoding = 'UTF-8')
