## code to prepare `longult` dataset goes here

longult <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/LONGULT_v1.txt"
longult <- readr::read_delim(longult, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(longult, overwrite = TRUE)
