## code to prepare `concept_id` dataset goes here

concept_id <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/ConceptIDKey_v1.txt"
concept_id <- readr::read_table(concept_id, col_names = FALSE, readr::cols(X1 = readr::col_character(), X2 = readr::col_character()))

usethis::use_data(concept_id, overwrite = TRUE)
