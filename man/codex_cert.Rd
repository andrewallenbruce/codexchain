% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codex_cert.R
\name{codex_cert}
\alias{codex_cert}
\title{Search the Medicare Fee-for-Service Comprehensive Error Rate Testing API}
\source{
Centers for Medicare & Medicaid Services
}
\usage{
codex_cert(
  year = 2021,
  part = NULL,
  drg = NULL,
  hcpcs = NULL,
  prov_type = NULL,
  bill_type = NULL,
  decision = NULL,
  error = NULL,
  clean_names = TRUE,
  lowercase = TRUE
)
}
\arguments{
\item{year}{YYYY, calendar year of CERT data. 2011-2021 data is currently
available.}

\item{part}{Type of Medicare Fee-for-Service claim}

\item{drg}{The Diagnosis Related Group code}

\item{hcpcs}{The Healthcare Common Procedure Coding System code}

\item{prov_type}{Type of provider providing the service}

\item{bill_type}{Type of Bill (TOB), Identifies type of facility, type of
care, and sequence of bill in a particular episode of care; e.g. "721",
"131", "110", "111"}

\item{decision}{Medical review decision for the claim; either \code{Agree}
or \code{Disagree}}

\item{error}{Reason the claim was in error; e.g. "Insufficient
Documentation", "Incorrect Coding"}

\item{clean_names}{Clean column names with {janitor}'s
\code{clean_names()} function; default is \code{TRUE}.}

\item{lowercase}{Convert column names to lowercase; default is \code{TRUE}.}
}
\value{
A \link[tibble:tibble-package]{tibble} containing the search results.
}
\description{
Information on Medicare Fee-for-Service (FFS) claims that
underwent Comprehensive Error Rate Testing (CERT) medical review. These
claims were used to calculate the Medicare FFS improper payment rate.
}
\details{
The Medicare Fee-for-Service (FFS) Comprehensive Error Rate
Testing (CERT) dataset provides information on a random sample of FFS
claims to determine if they were paid properly under Medicare coverage,
coding, and payment rules. The dataset contains information on type of
FFS claim, Diagnosis Related Group (DRG) and Healthcare Common Procedure
Coding System (HCPCS) codes, provider type, type of bill, review
decision, and error code. Please note, each reporting year contains
claims submitted July 1 two years before the report through June 30 one
year before the report. For example, the 2021 data contains claims
submitted July 1, 2019 through June 30, 2020.
\subsection{Links}{
\itemize{
\item \href{https://data.cms.gov/provider-compliance/fee-for-service-error-rate-improper-payment/medicare-fee-for-service-comprehensive-error-rate-testing}{Medicare Fee-for-Service Comprehensive Error Rate Testing}
}
}
}
\note{
Update Frequency: \strong{Annually}
}
\examples{
\dontrun{
codex_cert(hcpcs = "92002", decision = "Disagree")
}
}
