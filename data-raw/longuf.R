## code to prepare `longuf` dataset goes here

longuf <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/LONGUF_v1.txt"
longuf <- readr::read_delim(longuf, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(longuf, overwrite = TRUE)
