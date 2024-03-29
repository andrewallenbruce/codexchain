% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codex_ptp.R
\name{codex_ptp}
\alias{codex_ptp}
\title{Search CMS' NCCI Procedure to Procedure Edits (PTP) API}
\source{
Centers for Medicare & Medicaid Services
}
\usage{
codex_ptp(
  category = NULL,
  column_1 = NULL,
  column_2 = NULL,
  modifier_indicator = NULL,
  ptp_edit_rationale = NULL,
  clean_names = TRUE,
  lowercase = TRUE,
  explain = FALSE
)
}
\arguments{
\item{category}{Practitioner Services, Outpatient Hospital Services, DME Services}

\item{column_1}{HCPCS comprehensive code}

\item{column_2}{HCPCS component code}

\item{modifier_indicator}{\code{0} (Allowed), \code{1} (Not Allowed), \code{9} (Use Not Specified)}

\item{ptp_edit_rationale}{Choices:
\itemize{
\item "Misuse of column two code with column one code"
\item "Standards of medical / surgical practice"
\item "CPT Manual or CMS manual coding instructions"
\item "Standard preparation / monitoring services for anesthesia"
\item "Mutually exclusive procedures"
\item "More extensive procedure"
\item "HCPCS/CPT procedure code definition"
\item "CPT \"separate procedure\" definition"
\item "Anesthesia service included in surgical procedure"
\item "Sequential procedure"
\item "Laboratory panel"
\item "Gender-specific (formerly Designation of sex) procedures"
}}

\item{clean_names}{Clean column names with {janitor}'s
\code{clean_names()} function; default is \code{TRUE}.}

\item{lowercase}{Convert column names to lowercase; default is \code{TRUE}.}

\item{explain}{If \code{TRUE}, converts data to a more human-readable form;
default is \code{FALSE}.}
}
\value{
A \link[tibble:tibble-package]{tibble} containing the search results.
}
\description{
\code{\link[=codex_ptp]{codex_ptp()}} allows you to search CMS' NCCI Procedure
to Procedure Edits (PTP) API.
}
\details{
The CMS National Correct Coding Initiative (NCCI) promotes
national correct coding methodologies and reduces improper coding
which may result in inappropriate payments of Medicare Part B claims
and Medicaid claims. NCCI procedure-to-procedure (PTP) edits define
pairs of Healthcare Common Procedure Coding System (HCPCS)/Current
Procedural Terminology (CPT) codes that should not be reported together
for a variety of reasons. The purpose of the PTP edits is to prevent
improper payments when incorrect code combinations are reported.
Practitioner services also refers to ambulatory surgical centers.
DME refers to provider claims for durable medical equipment.
\subsection{Links}{
\itemize{
\item \href{https://data.medicaid.gov/dataset/bf3c4970-7dce-49df-b555-bb62ccf9ffb6}{CMS' NCCI Procedure to Procedure Edits (PTP) API}
}
}
}
\note{
Update Frequency: \strong{Quarterly}
}
\examples{
\dontrun{
codex_ptp(category = "DME Services")
codex_ptp(column_1 = "29000", modifier_indicator = "1")
codex_ptp(column_2 = "29015")
codex_ptp(modifier_indicator = "0")
codex_ptp(ptp_edit_rationale = "Mutually exclusive procedures")
}
}
