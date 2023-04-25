## code to prepare `longut` dataset goes here

longut <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/LONGUT_v1.txt"
longut <- readr::read_delim(longut, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(longut, overwrite = TRUE)
