#' Search CMS' NCCI Procedure to Procedure Edits (PTP) API
#'
#' @description [codex_ptp()] allows you to search CMS' NCCI Procedure
#'    to Procedure Edits (PTP) API.
#'
#' @details The CMS National Correct Coding Initiative (NCCI) promotes
#'    national correct coding methodologies and reduces improper coding
#'    which may result in inappropriate payments of Medicare Part B claims
#'    and Medicaid claims. NCCI procedure-to-procedure (PTP) edits define
#'    pairs of Healthcare Common Procedure Coding System (HCPCS)/Current
#'    Procedural Terminology (CPT) codes that should not be reported together
#'    for a variety of reasons. The purpose of the PTP edits is to prevent
#'    improper payments when incorrect code combinations are reported.
#'    Practitioner services also refers to ambulatory surgical centers.
#'    DME refers to provider claims for durable medical equipment.
#'
#' ## Links
#'  * [CMS' NCCI Procedure to Procedure Edits (PTP) API](https://data.medicaid.gov/dataset/bf3c4970-7dce-49df-b555-bb62ccf9ffb6)
#'
#' @source Centers for Medicare & Medicaid Services
#' @note Update Frequency: **Quarterly**
#'
#' @param category Practitioner Services, Outpatient Hospital Services, DME Services
#' @param column_1 HCPCS comprehensive code
#' @param column_2 HCPCS component code
#' @param modifier_indicator `0` (Allowed), `1` (Not Allowed), `9` (Use Not Specified)
#' @param ptp_edit_rationale Choices:
#'    - "Misuse of column two code with column one code"
#'    - "Standards of medical / surgical practice"
#'    - "CPT Manual or CMS manual coding instructions"
#'    - "Standard preparation / monitoring services for anesthesia"
#'    - "Mutually exclusive procedures"
#'    - "More extensive procedure"
#'    - "HCPCS/CPT procedure code definition"
#'    - "CPT \"separate procedure\" definition"
#'    - "Anesthesia service included in surgical procedure"
#'    - "Sequential procedure"
#'    - "Laboratory panel"
#'    - "Gender-specific (formerly Designation of sex) procedures"
#' @param clean_names Clean column names with {janitor}'s
#'    `clean_names()` function; default is `TRUE`.
#' @param lowercase Convert column names to lowercase; default is `TRUE`.
#' @param explain If `TRUE`, converts data to a more human-readable form;
#'    default is `FALSE`.
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' codex_ptp(category = "DME Services")
#' codex_ptp(column_1 = "29000", modifier_indicator = "1")
#' codex_ptp(column_2 = "29015")
#' codex_ptp(modifier_indicator = "0")
#' codex_ptp(ptp_edit_rationale = "Mutually exclusive procedures")
#' }
#' @autoglobal
#' @export
codex_ptp <- function(category = NULL,
                      column_1 = NULL,
                      column_2 = NULL,
                      modifier_indicator = NULL,
                      ptp_edit_rationale = NULL,
                      clean_names = TRUE,
                      lowercase   = TRUE,
                      explain = FALSE) {
  # args tribble ------------------------------------------------------------
  args <- tibble::tribble(
    ~x,                   ~y,
    "category",           category,
    "column_1",           column_1,
    "column_2",           column_2,
    "modifier_indicator", modifier_indicator,
    "ptp_edit_rationale", ptp_edit_rationale)

  # map param_format and collapse -------------------------------------------
  params_args <- purrr::map2(args$x, args$y, sql_format) |> unlist() |> stringr::str_flatten()

  # build URL ---------------------------------------------------------------
  http   <- "https://data.medicaid.gov/api/1/datastore/sql?query="
  id     <- "[SELECT * FROM c3aacd2c-0834-508e-b77f-14f276aa57b5]"
  post   <- "[LIMIT 10000 OFFSET 0]&show_db_columns"
  url    <- paste0(http, id, params_args, post) |> param_brackets() |> param_space()

  # send request ----------------------------------------------------------
  resp <- httr2::request(url) |> httr2::req_perform()

  # no search results returns empty tibble ----------------------------------
  if (httr2::resp_header(resp, "content-length") |> as.numeric() == 0) {

    results <- tibble::tibble(record_number = NA,
                              quarter_begin_date = NA,
                              category = NA,
                              column_1 = NA,
                              column_2 = NA,
                              effective_date = NA,
                              deletion_date = NA,
                              modifier_indicator = NA,
                              ptp_edit_rationale = NA)
    return(results)

  } else {

    # parse response ----------------------------------------------------------
    results <- tibble::tibble(httr2::resp_body_json(resp,
               check_type = FALSE, simplifyVector = TRUE))

    results <- results |>
      dplyr::mutate(
        quarter_begin_date = as.Date(quarter_begin_date),
        effective_date     = as.Date(effective_date),
        deletion_date      = as.Date(deletion_date),
        modifier_indicator = as.factor(modifier_indicator))

    if (isTRUE(explain)) {

      results <- results |>
        dplyr::rename(hcpcs_comprehensive = column_1,
                      hcpcs_component     = column_2,
                      modifier_use        = modifier_indicator,
                      reasoning           = ptp_edit_rationale)

      results <- results |>
        dplyr::mutate(modifier_use = dplyr::case_when(
          modifier_use == 0 ~ as.character("Allowed (0)"),
          modifier_use == 1 ~ as.character("Not Allowed (1)"),
          modifier_use == 9 ~ as.character("Use Not Specified (9)"),
          TRUE ~ as.character(modifier_use))) |>
        dplyr::mutate(modifier_use = as.factor(modifier_use))
    }

  }

  # clean names -------------------------------------------------------------
  if (isTRUE(clean_names)) {results <- janitor::clean_names(results)}
  # lowercase ---------------------------------------------------------------
  if (isTRUE(lowercase)) {results <- dplyr::rename_with(results, tolower)}

  return(results)
}
