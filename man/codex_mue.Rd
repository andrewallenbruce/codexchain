% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codex_mue.R
\name{codex_mue}
\alias{codex_mue}
\title{Search CMS' NCCI Medically Unlikely Edits (MUEs) API}
\source{
Centers for Medicare & Medicaid Services
}
\usage{
codex_mue(
  category = NULL,
  hcpcscpt_code = NULL,
  mue_value = NULL,
  mue_rationale = NULL,
  clean_names = TRUE,
  lowercase = TRUE
)
}
\arguments{
\item{category}{Practitioner Services, Outpatient Hospital Services, DME Services}

\item{hcpcscpt_code}{HCPCS code}

\item{mue_value}{integer. MUEs define the maximum units of service (UOS)
that a provider would report for each HCPCS / CPT code under most
circumstances for a single beneficiary on a single date of service.}

\item{mue_rationale}{Choices:
\itemize{
\item "Anatomic Consideration"
\item "Clinical: Medicare Data"
\item "Code Descriptor / CPT Instruction"
\item "Nature of Service / Procedure"
\item "CMS Policy"
\item "Nature of Equipment"
\item "Inpatient Procedure"
\item "Nature of Analyte"
\item "CMS NCCI Policy"
\item "Prescribing Information"
\item "Clinical: CMS Workgroup"
\item "Drug Discontinued"
\item "Clinical: Medicaid Data"
\item "Clinical: Society Comment"
\item "Nature of Service/Procedure"
\item NA
\item "Clinical: Data"
\item "does NOT appear on published file"
}}

\item{clean_names}{Clean column names with {janitor}'s
\code{clean_names()} function; default is \code{TRUE}.}

\item{lowercase}{Convert column names to lowercase; default is \code{TRUE}.}
}
\value{
A \link[tibble:tibble-package]{tibble} containing the search results.
}
\description{
\code{\link[=codex_mue]{codex_mue()}} allows you to search CMS' NCCI
Medically Unlikely Edits (MUEs) API.
}
\details{
Medically Unlikely Edits (MUEs) define for each HCPCS / CPT code
the maximum units of service (UOS) that a provider would report under
most circumstances for a single beneficiary on a single date of service.
Practitioner services also refers to ambulatory surgical centers. DME
refers to provider claims for durable medical equipment. The CMS National
Correct Coding Initiative (NCCI) promotes national correct coding
methodologies and reduces improper coding which may result in
inappropriate payments of Medicare Part B claims and Medicaid claims.
NCCI procedure-to-procedure (PTP) edits define pairs of Healthcare Common
Procedure Coding System (HCPCS)/Current Procedural Terminology (CPT)
codes that should not be reported together for a variety of reasons. The
purpose of the PTP edits is to prevent improper payments when incorrect
code combinations are reported. The edits in this dataset are active for
the dates indicated within. This file should NOT be used by state
Medicaid programs as their edit file. For more information, visit
https://www.medicaid.gov/medicaid/program-integrity/ncci/index.html.
\subsection{Links}{
\itemize{
\item \href{https://data.medicaid.gov/dataset/552def06-89ab-5f6f-a6de-90b27a792127}{CMS' NCCI Medically Unlikely Edits (MUEs) API}
}
}
}
\note{
Update Frequency: \strong{Quarterly}
}
\examples{
\dontrun{
codex_mue(category = "Practitioner Services")
codex_mue(hcpcscpt_code = "G0121")
codex_mue(mue_value = "1")
codex_mue(mue_rationale = "Anatomic Consideration")
}
}
