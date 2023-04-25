## code to prepare `shortu` dataset goes here

shortu <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/SHORTU_v1.txt"
shortu <- readr::read_delim(shortu, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(shortu, overwrite = TRUE)
