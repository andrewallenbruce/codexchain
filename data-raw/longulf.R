## code to prepare `longulf` dataset goes here

longulf <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/LONGULF_v1.txt"
longulf <- readr::read_delim(longulf, delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

usethis::use_data(longulf, overwrite = TRUE)
