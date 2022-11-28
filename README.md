
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `codexchain`

<!-- badges: start -->

[![R-CMD-check](https://github.com/andrewallenbruce/codexchain/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andrewallenbruce/codexchain/actions/workflows/R-CMD-check.yaml)
[![code
size](https://img.shields.io/github/languages/code-size/andrewallenbruce/codexchain.svg)](https://github.com/andrewallenbruce/codexchain)
[![Codecov test
coverage](https://codecov.io/gh/andrewallenbruce/codexchain/branch/master/graph/badge.svg)](https://app.codecov.io/gh/andrewallenbruce/codexchain?branch=master)
[![last
commit](https://img.shields.io/github/last-commit/andrewallenbruce/codexchain.svg)](https://github.com/andrewallenbruce/codexchain/commits/master)
[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![License: GPL (\>=
3)](https://img.shields.io/badge/license-GPL%20(%3E=%203)-blue.svg)](https://cran.r-project.org/web/licenses/GPL%20(%3E=%203))
<!-- badges: end -->

## Installation

You can install the development version of codexchain from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("andrewallenbruce/codexchain")

# install.packages("remotes")
remotes::install_github("andrewallenbruce/codexchain")
```

<br>

## NIH/NLM ICD-10-CM 2023 API

<br>

``` r
# Load library
library(codexchain)

# Return the seven ICD-10 codes beginning with "A15"
codex_icd10(code = "A15") |> 
            knitr::kable()
```

| icd_10_cm_code | icd_10_cm_term                               |
|:---------------|:---------------------------------------------|
| A15.0          | Tuberculosis of lung                         |
| A15.4          | Tuberculosis of intrathoracic lymph nodes    |
| A15.5          | Tuberculosis of larynx, trachea and bronchus |
| A15.6          | Tuberculous pleurisy                         |
| A15.7          | Primary respiratory tuberculosis             |
| A15.8          | Other respiratory tuberculosis               |
| A15.9          | Respiratory tuberculosis unspecified         |

<br>

``` r
# Return the first 20 ICD-10 codes associated with tuberculosis
codex_icd10(term = "tuber", 
            limit = 20) |> 
            knitr::kable()
```

| icd_10_cm_code | icd_10_cm_term                                    |
|:---------------|:--------------------------------------------------|
| A15.0          | Tuberculosis of lung                              |
| A15.4          | Tuberculosis of intrathoracic lymph nodes         |
| A15.5          | Tuberculosis of larynx, trachea and bronchus      |
| A15.6          | Tuberculous pleurisy                              |
| A15.7          | Primary respiratory tuberculosis                  |
| A15.8          | Other respiratory tuberculosis                    |
| A15.9          | Respiratory tuberculosis unspecified              |
| A17.0          | Tuberculous meningitis                            |
| A17.1          | Meningeal tuberculoma                             |
| A17.81         | Tuberculoma of brain and spinal cord              |
| A17.82         | Tuberculous meningoencephalitis                   |
| A17.83         | Tuberculous neuritis                              |
| A17.89         | Other tuberculosis of nervous system              |
| A17.9          | Tuberculosis of nervous system, unspecified       |
| A18.01         | Tuberculosis of spine                             |
| A18.02         | Tuberculous arthritis of other joints             |
| A18.03         | Tuberculosis of other bones                       |
| A18.09         | Other musculoskeletal tuberculosis                |
| A18.10         | Tuberculosis of genitourinary system, unspecified |
| A18.11         | Tuberculosis of kidney and ureter                 |

<br>

``` r
# Return the two ICD-10 codes associated with pleurisy
codex_icd10(term = "pleurisy") |> 
            knitr::kable()
```

| icd_10_cm_code | icd_10_cm_term       |
|:---------------|:---------------------|
| R09.1          | Pleurisy             |
| A15.6          | Tuberculous pleurisy |

<br>

When searching for ICD-10 codes by letter, you must set the `field`
param to “code” or it will search for *terms* containing the letter as
well:

<br>

``` r
# Without field = "code", returns terms containing the letter "Z":
codex_icd10(code = "Z", 
            limit = 5) |> 
            knitr::kable()
```

| icd_10_cm_code | icd_10_cm_term                                                        |
|:---------------|:----------------------------------------------------------------------|
| A28.8          | Other specified zoonotic bacterial diseases, not elsewhere classified |
| A28.9          | Zoonotic bacterial disease, unspecified                               |
| A92.5          | Zika virus disease                                                    |
| B02.0          | Zoster encephalitis                                                   |
| B02.1          | Zoster meningitis                                                     |

<br>

``` r
# With field = "code", returns only codes containing "Z":
codex_icd10(code = "z", 
            field = "code", 
            limit = 5) |> 
            knitr::kable()
```

| icd_10_cm_code | icd_10_cm_term                                                            |
|:---------------|:--------------------------------------------------------------------------|
| Z00.00         | Encounter for general adult medical examination without abnormal findings |
| Z00.01         | Encounter for general adult medical examination with abnormal findings    |
| Z00.110        | Health examination for newborn under 8 days old                           |
| Z00.111        | Health examination for newborn 8 to 28 days old                           |
| Z00.121        | Encounter for routine child health examination with abnormal findings     |

## Medicare Fee-for-Service Comprehensive Error Rate Testing API

<br>

``` r
codex_cert(hcpcs = "92002", 
           decision = "Disagree") |> 
           knitr::kable()
```

| year | claim_control_number | part       | drg | hcpcs_procedure_code | provider_type | type_of_bill | review_decision | error_code                 |
|-----:|---------------------:|:-----------|:----|:---------------------|:--------------|:-------------|:----------------|:---------------------------|
| 2021 |              2134770 | 1\. Part B |     | 92002                | Optometry     |              | Disagree        | Other                      |
| 2021 |              2136243 | 1\. Part B |     | 92002                | Ophthalmology |              | Disagree        | Insufficient Documentation |
| 2021 |              2139556 | 1\. Part B |     | 92002                | Optometry     |              | Disagree        | Incorrect Coding           |
| 2021 |              2142814 | 1\. Part B |     | 92002                | Ophthalmology |              | Disagree        | Incorrect Coding           |
| 2021 |              2139587 | 1\. Part B |     | 92002                | Ophthalmology |              | Disagree        | Incorrect Coding           |
| 2021 |              2146877 | 1\. Part B |     | 92002                | Optometry     |              | Disagree        | Incorrect Coding           |
| 2021 |              2145036 | 1\. Part B |     | 92002                | Ophthalmology |              | Disagree        | Incorrect Coding           |
| 2021 |              2145815 | 1\. Part B |     | 92002                | Optometry     |              | Disagree        | Incorrect Coding           |

<br>

## NCCI Procedure-to-Procedure Edits (PTP) API

<br>

``` r
codex_ptp() |> 
     head() |> 
     knitr::kable()
```

| record_number | quarter_begin_date | category     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale            |
|:--------------|:-------------------|:-------------|:---------|:---------|:---------------|:--------------|:-------------------|:------------------------------|
| 1             | 2022-10-01         | DME Services | 29000    | 29010    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 6             | 2022-10-01         | DME Services | 29000    | 29015    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 11            | 2022-10-01         | DME Services | 29000    | 29020    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 16            | 2022-10-01         | DME Services | 29000    | 29025    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 21            | 2022-10-01         | DME Services | 29000    | 29035    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 26            | 2022-10-01         | DME Services | 29000    | 29040    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |

<br>

``` r
codex_ptp(explain = TRUE) |> 
                   head() |> 
                   knitr::kable()
```

| record_number | quarter_begin_date | category     | hcpcs_comprehensive | hcpcs_component | effective_date | deletion_date | modifier_use | reasoning                     |
|:--------------|:-------------------|:-------------|:--------------------|:----------------|:---------------|:--------------|:-------------|:------------------------------|
| 1             | 2022-10-01         | DME Services | 29000               | 29010           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 6             | 2022-10-01         | DME Services | 29000               | 29015           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 11            | 2022-10-01         | DME Services | 29000               | 29020           | 2013-04-01     | 2014-12-31    | Allowed (0)  | Mutually exclusive procedures |
| 16            | 2022-10-01         | DME Services | 29000               | 29025           | 2013-04-01     | 2014-12-31    | Allowed (0)  | Mutually exclusive procedures |
| 21            | 2022-10-01         | DME Services | 29000               | 29035           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 26            | 2022-10-01         | DME Services | 29000               | 29040           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |

<br>

## NCCI Medically Unlikely Edits (MUEs) API

<br>

``` r
codex_mue() |> 
     head() |> 
     knitr::kable()
```

| quarter_begin_date | category                     | hcpcs_code | mue_value | mue_rationale                 |
|:-------------------|:-----------------------------|:-----------|----------:|:------------------------------|
| 2018-01-01         | Practitioner Services        | G0121      |         1 | Anatomic Consideration        |
| 2018-01-01         | Practitioner Services        | 90660      |         1 | Clinical: Medicare Data       |
| 2018-01-01         | Practitioner Services        | J9060      |        24 | Prescribing Information       |
| 2018-01-01         | Outpatient Hospital Services | 61781      |         1 | Nature of Service / Procedure |
| 2018-01-01         | Outpatient Hospital Services | 64913      |         3 | CMS NCCI Policy               |
| 2018-01-01         | Outpatient Hospital Services | 95146      |        10 | Clinical: Medicare Data       |

<br>
