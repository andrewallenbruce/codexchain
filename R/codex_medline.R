#' Search the MedlinePlus Connect API
#'
#' @description MedlinePlus Connect is a free service of the National Library of Medicine (NLM), National Institutes of Health (NIH), and the Department of Health and Human Services (HHS). This service allows health organizations and health IT providers to link patient portals and electronic health record (EHR) systems to MedlinePlus, an authoritative up-to-date health information resource for patients, families, and health care providers.
#'
#' @details TMedlinePlus Connect accepts and responds to requests for information based on diagnosis (problem) codes, medication codes, laboratory test codes, and medical procedure codes. When an EHR, patient portal or other system submits a code-based request, MedlinePlus Connect returns a response that includes links to patient education information relevant to the code.
#'
#' @source U.S. National Library of Medicine
#' @note [MedlinePlus Connect API](https://medlineplus.gov/medlineplus-connect/web-service/)
#'
#' @param code diagnosis (problem) code, medication code, laboratory test code, or procedure code
#' @param code_title You may also identify the name/title of the problem code. However, this information does not impact the response.
#' @param code_system ICD-9-CM, ICD-10-CM, CPT, SNOMED, RXCUI, or NDC
#' @param language Identify if you would like the response to be in English or Spanish. MedlinePlus Connect will assume English is the language if it is not specified.
#' @param format JSON, JSONP, or XML
#'
#' @return A [tibble][tibble::tibble-package] containing the search results.
#'
#' @examples
#' codex_medline(code_title = "Chantix 0.5 MG Oral Tablet", code_system = "rxcui")
#'
#' codex_medline(code = "00310-0751-39", code_system = "ndc")
#' @autoglobal
#' @export

codex_medline <- function(code = NULL,
                          code_system = NULL,
                          code_title = NULL,
                          language = "english",
                          format = "json") {

  # dataset version ids by year ----------------------------------------------
  lang <- dplyr::case_when(
    language == "english" ~ "informationRecipient.languageCode.c=en",
    language == "spanish" ~ "informationRecipient.languageCode.c=sp")

  # dataset version ids by year ----------------------------------------------
  cd_sys <- dplyr::case_when(
    code_system == "icd_9" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.103",
    code_system == "icd_10" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.90",
    code_system == "cpt" ~ "mainSearchCriteria.v.cs= 2.16.840.1.113883.6.12",
    code_system == "snomed" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.96",
    code_system == "rxcui" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.88",
    code_system == "loinc" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.1",
    code_system == "ndc" ~ "mainSearchCriteria.v.cs=2.16.840.1.113883.6.69")

  # dataset version ids by year ----------------------------------------------
  fmt <- dplyr::case_when(
    format == "json" ~ "knowledgeResponseType=application/json",
    format == "jsonp" ~ "knowledgeResponseType=application/javascript&callback=CallbackFunction",
    format == "xml" ~ "knowledgeResponseType=text/xml")

  # build URL ---------------------------------------------------------------
  code <- medline_format("mainSearchCriteria.v.c=", code)
  title <- medline_format("mainSearchCriteria.v.dn=", code_title)
  http   <- "https://connect.medlineplus.gov/service?"
  url    <- paste0(http, code, title, cd_sys, "&", lang, "&", fmt)

  # send request ----------------------------------------------------------
  resp <- httr2::request(url) |> httr2::req_perform()

  # parse response ----------------------------------------------------------
  res <- httr2::resp_body_json(resp, check_type = FALSE, simplifyVector = TRUE)

  results <- tibble::tibble(
    updated = lubridate::as_datetime(res$feed$updated[[1]]),
    entry_title = res$feed$entry$title$`_value`,
    source = res$feed$author$name[[1]],
    search_description = stringr::str_flatten(res$feed$category$term,
                                              collapse = ", ", na.rm = TRUE),
    results_description = res$feed$subtitle$`_value`[[1]],
    entry_link = res$feed$entry$link[[1]]$href,
    entry_summary = htm2txt::htm2txt(res$feed$entry$summary$`_value`))

  return(results)
}
