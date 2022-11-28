#' Search the Medicare Fee-for-Service Comprehensive Error Rate Testing API
#'
#' @description Information on Medicare Fee-for-Service (FFS) claims that
#'   underwent Comprehensive Error Rate Testing (CERT) medical review. These
#'   claims were used to calculate the Medicare FFS improper payment rate.
#'
#' @details The Medicare Fee-for-Service (FFS) Comprehensive Error Rate
#'    Testing (CERT) dataset provides information on a random sample of FFS
#'    claims to determine if they were paid properly under Medicare coverage,
#'    coding, and payment rules. The dataset contains information on type of
#'    FFS claim, Diagnosis Related Group (DRG) and Healthcare Common Procedure
#'    Coding System (HCPCS) codes, provider type, type of bill, review
#'    decision, and error code. Please note, each reporting year contains
#'    claims submitted July 1 two years before the report through June 30 one
#'    year before the report. For example, the 2021 data contains claims
#'    submitted July 1, 2019 through June 30, 2020.
#'
#' ## Links
#' * [Medicare Fee-for-Service Comprehensive Error Rate Testing](https://data.cms.gov/provider-compliance/fee-for-service-error-rate-improper-payment/medicare-fee-for-service-comprehensive-error-rate-testing)
#'
#' @source Centers for Medicare & Medicaid Services
#' @note Update Frequency: **Annually**
#'
#' @param year YYYY, calendar year of CERT data. 2011-2021 data is currently
#'    available.
#' @param part Type of Medicare Fee-for-Service claim
#' @param drg The Diagnosis Related Group code
#' @param hcpcs The Healthcare Common Procedure Coding System code
#' @param prov_type Type of provider providing the service
#' @param bill_type Type of Bill (TOB), Identifies type of facility, type of
#'    care, and sequence of bill in a particular episode of care; e.g. "721",
#'    "131", "110", "111"
#' @param decision Medical review decision for the claim; either `Agree`
#'    or `Disagree`
#' @param error Reason the claim was in error; e.g. "Insufficient
#'    Documentation", "Incorrect Coding"
#' @param clean_names Clean column names with {janitor}'s
#'    `clean_names()` function; default is `TRUE`.
#' @param lowercase Convert column names to lowercase; default is `TRUE`.
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' codex_cert(hcpcs = "92002", decision = "Disagree")
#' }
#' @autoglobal
#' @export

codex_cert <- function(year        = 2021,
                       part        = NULL,
                       drg         = NULL,
                       hcpcs       = NULL,
                       prov_type   = NULL,
                       bill_type   = NULL,
                       decision    = NULL,
                       error       = NULL,
                       clean_names = TRUE,
                       lowercase   = TRUE) {

  # dataset version ids by year ---------------------------------------------
  id <- dplyr::case_when(year == 2021 ~ "6395b458-2f89-4828-8c1a-e1e16b723d48",
                         year == 2020 ~ "8e02cc09-8179-4aaf-a437-c6012642f9af",
                         year == 2019 ~ "6b92a8b2-efaa-49ae-8a01-1922ef1fe534",
                         year == 2018 ~ "e9d0fb3a-ca8d-4e80-8bd3-0ae336ac76e6",
                         year == 2017 ~ "bcdc6155-64f8-4f0d-8ae4-dd31cfd3b61e",
                         year == 2016 ~ "13a30957-b6e7-4d4e-b82c-a88b581d1ac9",
                         year == 2015 ~ "b974bc10-e684-4972-80fa-b2280bb2f018",
                         year == 2014 ~ "d7e943c8-853e-4cb0-ae1d-9ba37414e451",
                         year == 2013 ~ "151d88cc-4872-4567-8a65-7afbd6b8f60b",
                         year == 2012 ~ "e14016d4-599b-4cf9-b1d8-da6953947bb8",
                         year == 2011 ~ "e171a6e4-21a9-4eed-aed5-fd6f845bdccb")

  # part param choices ------------------------------------------------------
  if (!is.null(part)) {
  part <- dplyr::case_when(part == "b" ~ "1.Part B",
    part == "dme" ~ "2. DME MAC",
    part == "aex" ~ "3. Part A(Excluding Inpatient Hospital PPS)",
    part == "ain" ~ "4. Part A(Inpatient Hospital PPS)")}

  # args tribble ------------------------------------------------------------
  args <- tibble::tribble(
    ~x,                             ~y,
    "Part",                       part,
    "DRG",                         drg,
    "HCPCS Procedure Code",      hcpcs,
    "Provider Type",         prov_type,
    "Type of Bill",          bill_type,
    "Review Decision",        decision,
    "Error Code",                error)

  # map param_format and collapse -------------------------------------------
  params_args <- purrr::map2(args$x, args$y, param_format) |> unlist() |>
    stringr::str_c(collapse = "") |> param_space()

  # build URL ---------------------------------------------------------------
  http   <- "https://data.cms.gov/data-api/v1/dataset/"
  post   <- "/data.json?"
  url    <- paste0(http, id, post, params_args)

  # send request ----------------------------------------------------------
  resp <- httr2::request(url) |> httr2::req_perform()

  # parse response ----------------------------------------------------------
  results <- tibble::tibble(httr2::resp_body_json(resp, check_type = FALSE,
             simplifyVector = TRUE)) |> dplyr::mutate(Year = year) |>
             dplyr::relocate(Year)

  # clean names -------------------------------------------------------------
  if (isTRUE(clean_names)) {results <- janitor::clean_names(results)}
  # lowercase ---------------------------------------------------------------
  if (isTRUE(lowercase)) {results <- dplyr::rename_with(results, tolower)}

  return(results)
}
