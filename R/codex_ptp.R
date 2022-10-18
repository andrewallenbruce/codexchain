#' Search CMS' NCCI Procedure to Procedure Edits (PTP) API
#'
#' @description [codex_ptp()] allows you to search CMS' NCCI Procedure
#'    to Procedure Edits (PTP) API.
#'
#' # NCCI Procedure to Procedure Edits (PTP)
#'
#' The CMS National Correct Coding Initiative (NCCI) promotes national
#' correct coding methodologies and reduces improper coding which may result
#' in inappropriate payments of Medicare Part B claims and Medicaid claims.
#' NCCI procedure-to-procedure (PTP) edits define pairs of Healthcare Common
#' Procedure Coding System (HCPCS)/Current Procedural Terminology (CPT) codes
#' that should not be reported together for a variety of reasons. The purpose
#' of the PTP edits is to prevent improper payments when incorrect code
#' combinations are reported. Practitioner services also refers to ambulatory
#' surgical centers. DME refers to provider claims for durable medical
#' equipment.
#'
#' ## Data Source
#' Centers for Medicare & Medicaid Services
#'
#' ## Links
#'  * [CMS' NCCI Procedure to Procedure Edits (PTP) API](https://data.medicaid.gov/dataset/bf3c4970-7dce-49df-b555-bb62ccf9ffb6)
#'
#' @param explain If `TRUE`, converts data to a more human-readable form;
#'    default is `FALSE`.
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' # Returns the first 10,000 results
#'
#' codex_ptp()
#'
#' codex_ptp(explain = TRUE)
#' }
#' @export

codex_ptp <- function(explain = FALSE) {

  # Check internet connection
  attempt::stop_if_not(
    curl::has_internet() == TRUE,
    msg = "Please check your internet connection.")

  # Medicare Order and Referring Base URL
  ptp_url <- "https://data.medicaid.gov/api/1/datastore/query/bf3c4970-7dce-49df-b555-bb62ccf9ffb6/0"

  # Create request
  req <- httr2::request(ptp_url)

  # Send and save response
  resp <- req |>
    httr2::req_url_query() |>
    httr2::req_perform()

  # Parse JSON response and save results
  res <- resp |> httr2::resp_body_json(
    check_type = FALSE,
    simplifyVector = TRUE)

  results <- res$results |> tibble::tibble()

  results <- results |>
    dplyr::mutate(
      quarter_begin_date = as.Date(quarter_begin_date),
      effective_date = as.Date(effective_date),
      deletion_date = as.Date(deletion_date),
      modifier_indicator = as.integer(modifier_indicator))

  if (isTRUE(explain)) {

    results <- results |>
      dplyr::rename(comprehensive = column_1,
                    component     = column_2,
                    modifier      = modifier_indicator,
                    reason        = ptp_edit_rationale)

    results <- results |>
      dplyr::mutate(modifier = dplyr::case_when(
        modifier == 0 ~ as.character("Allowed"),
        modifier == 1 ~ as.character("Not Allowed"),
        modifier == 9 ~ as.character("Use Not Specified"),
        TRUE ~ as.character(modifier)))
  }

  return(results)
}
