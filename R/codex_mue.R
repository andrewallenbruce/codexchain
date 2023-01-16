#' Search CMS' NCCI Medically Unlikely Edits (MUEs) API
#'
#' @description [codex_mue()] allows you to search CMS' NCCI
#'    Medically Unlikely Edits (MUEs) API.
#'
#' @details Medically Unlikely Edits (MUEs) define for each HCPCS / CPT code
#'    the maximum units of service (UOS) that a provider would report under
#'    most circumstances for a single beneficiary on a single date of service.
#'    Practitioner services also refers to ambulatory surgical centers. DME
#'    refers to provider claims for durable medical equipment. The CMS National
#'    Correct Coding Initiative (NCCI) promotes national correct coding
#'    methodologies and reduces improper coding which may result in
#'    inappropriate payments of Medicare Part B claims and Medicaid claims.
#'    NCCI procedure-to-procedure (PTP) edits define pairs of Healthcare Common
#'    Procedure Coding System (HCPCS)/Current Procedural Terminology (CPT)
#'    codes that should not be reported together for a variety of reasons. The
#'    purpose of the PTP edits is to prevent improper payments when incorrect
#'    code combinations are reported. The edits in this dataset are active for
#'    the dates indicated within. This file should NOT be used by state
#'    Medicaid programs as their edit file. For more information, visit
#'    https://www.medicaid.gov/medicaid/program-integrity/ncci/index.html.
#'
#' ## Links
#'  * [CMS' NCCI Medically Unlikely Edits (MUEs) API](https://data.medicaid.gov/dataset/552def06-89ab-5f6f-a6de-90b27a792127)
#'
#' @source Centers for Medicare & Medicaid Services
#' @note Update Frequency: **Quarterly**
#'
#' @param category Practitioner Services, Outpatient Hospital Services, DME Services
#' @param hcpcscpt_code HCPCS code
#' @param mue_value integer. MUEs define the maximum units of service (UOS)
#'    that a provider would report for each HCPCS / CPT code under most
#'    circumstances for a single beneficiary on a single date of service.
#' @param mue_rationale Choices:
#'    - "Anatomic Consideration"
#'    - "Clinical: Medicare Data"
#'    - "Code Descriptor / CPT Instruction"
#'    - "Nature of Service / Procedure"
#'    - "CMS Policy"
#'    - "Nature of Equipment"
#'    - "Inpatient Procedure"
#'    - "Nature of Analyte"
#'    - "CMS NCCI Policy"
#'    - "Prescribing Information"
#'    - "Clinical: CMS Workgroup"
#'    - "Drug Discontinued"
#'    - "Clinical: Medicaid Data"
#'    - "Clinical: Society Comment"
#'    - "Nature of Service/Procedure"
#'    - NA
#'    - "Clinical: Data"
#'    - "does NOT appear on published file"
#' @param clean_names Clean column names with {janitor}'s
#'    `clean_names()` function; default is `TRUE`.
#' @param lowercase Convert column names to lowercase; default is `TRUE`.
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' codex_mue(category = "Practitioner Services")
#' codex_mue(hcpcscpt_code = "G0121")
#' codex_mue(mue_value = "1")
#' codex_mue(mue_rationale = "Anatomic Consideration")
#' }
#' @autoglobal
#' @export
codex_mue <- function(category = NULL,
                      hcpcscpt_code = NULL,
                      mue_value = NULL,
                      mue_rationale = NULL,
                      clean_names = TRUE,
                      lowercase   = TRUE) {

  # args tribble ------------------------------------------------------------
  args <- tibble::tribble(
    ~x,                   ~y,
    "category",           category,
    "hcpcscpt_code",      hcpcscpt_code,
    "mue_value",          mue_value,
    "mue_rationale",      mue_rationale)

  # map param_format and collapse -------------------------------------------
  params_args <- purrr::map2(args$x, args$y, sql_format) |>
    unlist() |> stringr::str_flatten()

  # build URL ---------------------------------------------------------------
  http   <- "https://data.medicaid.gov/api/1/datastore/sql?query="
  id     <- "[SELECT * FROM 7e785fe3-1e07-5f75-ae44-1bb1333e66d7]"
  post   <- "[LIMIT 10000 OFFSET 0]&show_db_columns"
  url    <- paste0(http, id, params_args, post) |>
    param_brackets() |> param_space()

  # send request ----------------------------------------------------------
  resp <- httr2::request(url) |> httr2::req_perform()

  # no search results returns empty tibble ----------------------------------
  if (httr2::resp_header(resp, "content-length") |> as.numeric() == 0) {

    results <- tibble::tibble(record_number = NA,
                              quarter_begin_date = NA,
                              category = NA,
                              hcpcscpt_code = NA,
                              mue_value = NA,
                              mue_rationale = NA)
    return(results)

  } else {

    # parse response ----------------------------------------------------------
    results <- tibble::tibble(httr2::resp_body_json(resp,
                check_type = FALSE, simplifyVector = TRUE))

    results <- results |>
      dplyr::mutate(quarter_begin_date = as.Date(quarter_begin_date),
                    mue_value = as.integer(mue_value)) |>
      dplyr::rename(hcpcs_code = hcpcscpt_code)
  }

  # clean names -------------------------------------------------------------
  if (isTRUE(clean_names)) {results <- janitor::clean_names(results)}
  # lowercase ---------------------------------------------------------------
  if (isTRUE(lowercase)) {results <- dplyr::rename_with(results, tolower)}

  return(results)
}
