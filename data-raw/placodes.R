## code to prepare `placodes` dataset goes here

placodes <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/Proprietary Laboratory Analyses (PLA) Codes/CPTPLATab.txt"
placodes <- readr::read_delim(placodes, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(placodes, overwrite = TRUE)
