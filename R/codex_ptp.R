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
#' @param category definition
#' @param comprehensive definition
#' @param component definition
#' @param mod definition
#' @param reason definition
#' @param limit definition
#' @param offset definition
#' @param count definition
#' @param results definition
#' @param schema definition
#' @param keys definition
#' @param format definition
#' @param rowIds definition
#' @param explain definition
#' @param explain If `TRUE`, converts data to a more human-readable form;
#'    default is `FALSE`.
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' \dontrun{
#' # Returns the first 10,000 results
#'
#' codex_ptp(category = "DME",
#'           comprehensive = 29000,
#'           component = 29010,
#'           mod = 0,
#'           reason = "mutually",
#'           explain = TRUE)
#'
#' codex_ptp(explain = TRUE)
#' }
#' @autoglobal
#' @export

codex_ptp <- function(category = NULL,
                      comprehensive = NULL,
                      component = NULL,
                      mod = NULL,
                      reason = NULL,
                      limit = NULL,
                      offset = 0,
                      count = "true",
                      results = "true",
                      schema = "true",
                      keys = "true",
                      format = "json",
                      rowIds = "true",
                      explain = FALSE) {

  # Check internet connection
  attempt::stop_if_not(
    curl::has_internet() == TRUE,
    msg = "Please check your internet connection.")

  # Paste URL together
  http    <- "https://data.medicaid.gov/api/1/datastore/query/"
  id      <- "bf3c4970-7dce-49df-b555-bb62ccf9ffb6" # Q422

  if (!is.null(category))      {fcateg  <- paste0("filter[category]=", category)} else {fcateg <- NA}
  if (!is.null(comprehensive)) {fcompre <- paste0("filter[column_1]=", comprehensive)} else {fcompre <- NA}
  if (!is.null(component))     {fcompon     <- paste0("filter[column_2]=", component)} else {fcompon <- NA}
  if (!is.null(mod))           {fmodin            <- paste0("filter[modifier_indicator]=", mod)} else {fmodin <- NA}
  if (!is.null(reason))        {freason        <- paste0("filter[ptp_edit_rationale]=", reason)} else {freason <- NA}

  if (!is.null(limit)) {limit  <- paste0("limit=", limit)} else {limit <- NA}
  if (!is.null(offset)) {offset  <- paste0("offset=", offset)} else {offset <- NA}

  if (!is.null(count)) {count  <- paste0("count=", count)} else {count <- NA}
  if (!is.null(results)) {results  <- paste0("results=", results)} else {results <- NA}
  if (!is.null(schema)) {schema  <- paste0("schema=", schema)} else {schema <- NA}

  if (!is.null(keys)) {keys  <- paste0("keys=", keys)} else {keys <- NA}
  if (!is.null(format)) {format  <- paste0("format=", format)} else {format <- NA}
  if (!is.null(rowIds)) {rowIds  <- paste0("rowIds=", rowIds)} else {rowIds <- NA}

  # Create list of arguments
  args <- stringr::str_c(stringr::str_replace_na(c(fcateg,
                                                   fcompre,
                                                   fcompon,
                                                   fmodin,
                                                   freason,
                                                   limit,
                                                   offset,
                                                   count,
                                                   results,
                                                   schema,
                                                   keys,
                                                   format,
                                                   rowIds), ""),collapse = "&")

  ptp_url <- paste0(http, id, "/0?", args)

  # Create request
  req <- httr2::request(ptp_url)

  # Send and save response
  resp <- req |> httr2::req_perform()

  # Parse JSON response and save results
  res <- resp |> httr2::resp_body_json(
    check_type = FALSE,
    simplifyVector = TRUE)

  results <- res$results |> tibble::tibble()

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

  return(results)
}
