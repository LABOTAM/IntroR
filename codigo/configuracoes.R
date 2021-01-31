##################
## Prepara .gitignore
##################
library(gitignore)
new_lines <- gi_fetch_templates("R")
gi_write_gitignore(fetched_template = new_lines)
