## code to prepare `modul` dataset goes here

modul <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/MODUL_v1.txt"
modul <- readr::read_delim(modul, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(modul, overwrite = TRUE)
