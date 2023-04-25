## code to prepare `consumer` dataset goes here

consumer <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/Consumer Friendly Descriptors/ConsumerDescriptor.xlsx"
consumer <- readxl::read_xlsx(consumer) |> janitor::clean_names()

usethis::use_data(consumer, overwrite = TRUE)
