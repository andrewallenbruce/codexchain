## code to prepare `medu` dataset goes here

medu <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/MEDU_v1.txt"
medu <- readr::read_delim(medu, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(medu, overwrite = TRUE)
