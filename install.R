install_packages <- function() {
  cran_packages <- c(
    "remotes", "knitr", "rmarkdown", "data.table", "hdf5r",
    "ggplot2", "ggraph", "ggforce", "concaveman", "ggtext",
    "patchwork", "scales", "tidygraph", "viridis"
  )
  to_install <- cran_packages[!cran_packages %in% installed.packages()[, "Package"]]
  if (length(to_install)) install.packages(to_install)

  # igraph 2.3.3: the version used to create data/llm_labels.rds
  remotes::install_version("igraph", "2.3.3", upgrade = "never")

  # coorsim is only on GitHub: fixed commit
  remotes::install_github("thieled/coorsim@231617d405890341eed652037088e1136e696f47",
                          upgrade = "never")
}
install_packages()
