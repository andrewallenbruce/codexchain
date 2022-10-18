#' Search CMS' NCCI Medically Unlikely Edits (MUEs) API
#'
#' @description [codex_mue()] allows you to search CMS' NCCI
#'    Medically Unlikely Edits (MUEs) API.
#'
#' # NCCI Medically Unlikely Edits (MUEs)
#'
#' Medically Unlikely Edits (MUEs) define for each HCPCS / CPT code the
#' maximum units of service (UOS) that a provider would report under most
#' circumstances for a single beneficiary on a single date of service.
#' Practitioner services also refers to ambulatory surgical centers. DME
#' refers to provider claims for durable medical equipment.
#'
#' The CMS National Correct Coding Initiative (NCCI) promotes national
#' correct coding methodologies and reduces improper coding which may
#' result in inappropriate payments of Medicare Part B claims and Medicaid
#' claims. NCCI procedure-to-procedure (PTP) edits define pairs of
#' Healthcare Common Procedure Coding System (HCPCS)/Current Procedural
#' Terminology (CPT) codes that should not be reported together for a
#' variety of reasons.
#'
#' The purpose of the PTP edits is to prevent improper payments when
#' incorrect code combinations are reported. The edits in this dataset
#' are active for the dates indicated within. This file should NOT be used
#' by state Medicaid programs as their edit file. For more information,
#' visit https://www.medicaid.gov/medicaid/program-integrity/ncci/index.html.
#'
#' ## Data Source
#' Centers for Medicare & Medicaid Services
#'
#' ## Links
#'  * [CMS' NCCI Medically Unlikely Edits (MUEs) API](https://data.medicaid.gov/dataset/552def06-89ab-5f6f-a6de-90b27a792127)
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' # Returns the first 10,000 results
#'
#' codex_mue()
#' }
#' @export

codex_mue <- function() {

  # Check internet connection
  attempt::stop_if_not(
    curl::has_internet() == TRUE,
    msg = "Please check your internet connection.")

  # Medicare Order and Referring Base URL
  mue_url <- "https://data.medicaid.gov/api/1/datastore/query/552def06-89ab-5f6f-a6de-90b27a792127/0"

  # Create request
  req <- httr2::request(mue_url)

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
    dplyr::mutate(quarter_begin_date = as.Date(quarter_begin_date),
                  mue_value = as.integer(mue_value))

  results <- results |>
    dplyr::rename(hcpcs_code = hcpcscpt_code)

  return(results)
}
