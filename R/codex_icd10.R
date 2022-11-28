#' Search the National Library of Medicine's ICD-10-CM API
#'
#' @description [codex_icd10()] allows you to search the NLM's ICD-10-CM
#'    API by code or associated term.
#'
#' @details ICD-10-CM (International Classification of Diseases, 10th Revision,
#' Clinical Modification) is a medical coding system for classifying
#' diagnoses and reasons for visits in U.S. health care settings.
#'
#' ## Links
#'  * [NIH NLM Clinical Table Service ICD-10-CM API](https://clinicaltables.nlm.nih.gov/apidoc/icd10cm/v3/doc.html)
#'  * [Learn more about ICD-10-CM.](http://www.cdc.gov/nchs/icd/icd10cm.htm)
#'
#' @note Current Version: ICD-10-CM **2023**
#' @source National Institute of Health/National Library of Medicine
#'
#' @param code All or part of an ICD-10-CM code
#' @param term Associated term describing an ICD-10 code
#' @param field options are "code" or "both"; default is "both"
#' @param limit API limit is 500; defaults to 10
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#'
#' @examples
#' # Returns the seven codes beginning with "A15"
#' codex_icd10(code = "A15")
#'
#' # Returns the first five codes associated with tuberculosis
#' codex_icd10(term = "tuber", limit = 5)
#'
#' # Returns the two codes associated with pleurisy
#' codex_icd10(term = "pleurisy")
#'
#' # If you're searching for codes beginning with a certain letter, you
#' # must set the `field` param to "code" or it will search for terms as well:
#'
#' # Returns terms containing the letter "Z"
#' codex_icd10(code = "z", limit = 5)
#'
#' # Returns codes beginning with "Z"
#' codex_icd10(code = "z", field = "code")
#' @autoglobal
#' @export

codex_icd10 <- function(code  = NULL,
                        term  = NULL,
                        field = "both",
                        limit = 10) {

  # args --------------------------------------------------------------------
  args <- stringr::str_c(c(code = code, term = term), collapse = ",")

  # switch ------------------------------------------------------------------
  if (!is.null(field)) {switch(field,
    "code" = field <- "code",
    "both" = field <- "code,name",
    stop("field must be either `code` or `both`."))}

  # build URL ---------------------------------------------------------------
  url <- "https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?"

  # send request ----------------------------------------------------------
  resp <- httr2::request(url) |>
    httr2::req_url_query(terms = args, maxList = limit, sf = field) |>
    httr2::req_perform()

  # parse response ----------------------------------------------------------
  results <- resp |> httr2::resp_body_json(check_type = TRUE,
                                           simplifyVector = TRUE,
                                           simplifyMatrix = TRUE)

  # rename cols, convert to tibble ------------------------------------------
  results <- results[[4]] |> as.data.frame() |>
    dplyr::rename(icd_10_cm_code = V1, icd_10_cm_term = V2) |>
    tibble::tibble()

  return(results)

}
