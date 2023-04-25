## code to prepare `clinician` dataset goes here

clinician <- "D:/PLA Code Data Files_ 2022_Q4-20230420T013346Z-001/PLA Code Data Files_ 2022_Q4/Clinician Descriptors/ClinicianDescriptor.xlsx"
clinician <- readxl::read_xlsx(clinician) |> janitor::clean_names()

usethis::use_data(clinician, overwrite = TRUE)
