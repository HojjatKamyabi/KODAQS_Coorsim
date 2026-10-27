install_packages <- function() {
  cran_packages <- c(
    "pak", "knitr", "rmarkdown", "data.table", "hdf5r",
    "ggplot2", "ggraph", "ggforce", "concaveman", "ggtext",
    "patchwork", "scales", "tidygraph", "viridis"
  )
  to_install <- cran_packages[!cran_packages %in% installed.packages()[, "Package"]]
  if (length(to_install)) install.packages(to_install)

  # coorsim
  pak::pak("thieled/coorsim@231617d405890341eed652037088e1136e696f47")
}
install_packages()
