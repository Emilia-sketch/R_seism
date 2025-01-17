#....................................
#
#....................................
install_github("hydroversebr/hydrobr", build_vignettes=T)
vignette(package = "hydrobr")

library(hydrobr)
library(devtools)

inv_flu_rs <- inventory(states="SP", stationType = "plu", as_sf=T)
str(inv_flu_rs)

View(inv_flu_rs)
