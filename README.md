
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

``` r
# load library
library(codexchain)
```

## National Library of Medicine’s **ICD-10-CM 2023** API

The *International Classification of Diseases, 10th Revision, Clinical
Modification* is the American modification of the World Health
Organization’s ICD-10, a medical coding system for classifying diagnoses
and reasons for healthcare visits.

Return the seven ICD-10-CM codes beginning with “A15”

``` r
codex_icd10(code = "A15") |> 
     gluedown::md_table()
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

Return the first 20 ICD-10-CM codes associated with tuberculosis

``` r
codex_icd10(term = "tuber", 
            limit = 20) |> 
            gluedown::md_table()
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

Return the two ICD-10-CM codes associated with pleurisy

``` r
codex_icd10(term = "pleurisy") |> 
           gluedown::md_table()
```

| icd_10_cm_code | icd_10_cm_term       |
|:---------------|:---------------------|
| R09.1          | Pleurisy             |
| A15.6          | Tuberculous pleurisy |

<br>

When searching for ICD-10-CM codes by letter, you must set the `field`
param to “code” or it will search for *terms* containing the letter as
well. For example, without `field = "code"`, the following returns terms
containing the letter “Z”:

``` r
codex_icd10(code = "Z", 
            limit = 10) |> 
   gluedown::md_table()
```

| icd_10_cm_code | icd_10_cm_term                                                        |
|:---------------|:----------------------------------------------------------------------|
| A28.8          | Other specified zoonotic bacterial diseases, not elsewhere classified |
| A28.9          | Zoonotic bacterial disease, unspecified                               |
| A92.5          | Zika virus disease                                                    |
| B02.0          | Zoster encephalitis                                                   |
| B02.1          | Zoster meningitis                                                     |
| B02.30         | Zoster ocular disease, unspecified                                    |
| B02.31         | Zoster conjunctivitis                                                 |
| B02.32         | Zoster iridocyclitis                                                  |
| B02.33         | Zoster keratitis                                                      |
| B02.34         | Zoster scleritis                                                      |

<br>

With `field = "code"`, it returns only codes containing “Z”:

``` r
codex_icd10(code = "z", 
            field = "code", 
            limit = 10) |> 
      gluedown::md_table()
```

| icd_10_cm_code | icd_10_cm_term                                                                           |
|:---------------|:-----------------------------------------------------------------------------------------|
| Z00.00         | Encounter for general adult medical examination without abnormal findings                |
| Z00.01         | Encounter for general adult medical examination with abnormal findings                   |
| Z00.110        | Health examination for newborn under 8 days old                                          |
| Z00.111        | Health examination for newborn 8 to 28 days old                                          |
| Z00.121        | Encounter for routine child health examination with abnormal findings                    |
| Z00.129        | Encounter for routine child health examination without abnormal findings                 |
| Z00.2          | Encounter for examination for period of rapid growth in childhood                        |
| Z00.3          | Encounter for examination for adolescent development state                               |
| Z00.5          | Encounter for examination of potential donor of organ and tissue                         |
| Z00.6          | Encounter for examination for normal comparison and control in clinical research program |

<br> <br>

## BMI Coding Example

``` r
codex_icd10(term = "bmi adult", 
            limit = 30) |> 
  gluedown::md_table()
```

| icd_10_cm_code | icd_10_cm_term                               |
|:---------------|:---------------------------------------------|
| Z68.45         | Body mass index \[BMI\] 70 or greater, adult |
| Z68.1          | Body mass index \[BMI\] 19.9 or less, adult  |
| Z68.20         | Body mass index \[BMI\] 20.0-20.9, adult     |
| Z68.21         | Body mass index \[BMI\] 21.0-21.9, adult     |
| Z68.22         | Body mass index \[BMI\] 22.0-22.9, adult     |
| Z68.23         | Body mass index \[BMI\] 23.0-23.9, adult     |
| Z68.24         | Body mass index \[BMI\] 24.0-24.9, adult     |
| Z68.25         | Body mass index \[BMI\] 25.0-25.9, adult     |
| Z68.26         | Body mass index \[BMI\] 26.0-26.9, adult     |
| Z68.27         | Body mass index \[BMI\] 27.0-27.9, adult     |
| Z68.28         | Body mass index \[BMI\] 28.0-28.9, adult     |
| Z68.29         | Body mass index \[BMI\] 29.0-29.9, adult     |
| Z68.30         | Body mass index \[BMI\] 30.0-30.9, adult     |
| Z68.31         | Body mass index \[BMI\] 31.0-31.9, adult     |
| Z68.32         | Body mass index \[BMI\] 32.0-32.9, adult     |
| Z68.33         | Body mass index \[BMI\] 33.0-33.9, adult     |
| Z68.34         | Body mass index \[BMI\] 34.0-34.9, adult     |
| Z68.35         | Body mass index \[BMI\] 35.0-35.9, adult     |
| Z68.36         | Body mass index \[BMI\] 36.0-36.9, adult     |
| Z68.37         | Body mass index \[BMI\] 37.0-37.9, adult     |
| Z68.38         | Body mass index \[BMI\] 38.0-38.9, adult     |
| Z68.39         | Body mass index \[BMI\] 39.0-39.9, adult     |
| Z68.41         | Body mass index \[BMI\] 40.0-44.9, adult     |
| Z68.42         | Body mass index \[BMI\] 45.0-49.9, adult     |
| Z68.43         | Body mass index \[BMI\] 50.0-59.9, adult     |
| Z68.44         | Body mass index \[BMI\] 60.0-69.9, adult     |

<br>

``` r
NHANES::NHANES |> 
  dplyr::slice_sample(n = 30) |> 
  janitor::clean_names() |> 
  dplyr::filter(age >= 20) |> 
  dplyr::select(age, weight, height) |> 
  dplyr::mutate(
    weight = units::set_units(weight, kg),
    height = units::set_units(height, cm),
    body_mass_index = bmi_adult(weight = weight, height = height),
    icd_10_code = assign_bmi_icd(body_mass_index),
    bmi_status = assign_bmi_status(body_mass_index)) |> 
  gluedown::md_table()
```

| age |       weight |       height |     body_mass_index | icd_10_code | bmi_status     |
|----:|-------------:|-------------:|--------------------:|:------------|:---------------|
|  62 |  99.0 \[kg\] | 166.1 \[cm\] | 35.88359 \[kg/m^2\] | Z68.35      | Obese          |
|  79 | 103.6 \[kg\] | 172.6 \[cm\] | 34.77588 \[kg/m^2\] | Z68.34      | Obese          |
|  47 |  87.6 \[kg\] | 174.7 \[cm\] | 28.70241 \[kg/m^2\] | Z68.28      | Overweight     |
|  68 |  72.7 \[kg\] | 159.2 \[cm\] | 28.68457 \[kg/m^2\] | Z68.28      | Overweight     |
|  52 |  58.7 \[kg\] | 146.4 \[cm\] | 27.38772 \[kg/m^2\] | Z68.27      | Overweight     |
|  53 |  87.5 \[kg\] | 163.7 \[cm\] | 32.65207 \[kg/m^2\] | Z68.32      | Obese          |
|  61 |  71.5 \[kg\] | 160.6 \[cm\] | 27.72139 \[kg/m^2\] | Z68.27      | Overweight     |
|  73 |  66.8 \[kg\] | 157.3 \[cm\] | 26.99722 \[kg/m^2\] | Z68.26      | Overweight     |
|  49 |  74.6 \[kg\] | 177.1 \[cm\] | 23.78492 \[kg/m^2\] | Z68.23      | Healthy Weight |
|  59 |  95.4 \[kg\] | 173.7 \[cm\] | 31.61904 \[kg/m^2\] | Z68.31      | Obese          |
|  24 |  66.8 \[kg\] | 164.4 \[cm\] | 24.71570 \[kg/m^2\] | Z68.24      | Healthy Weight |
|  57 |  81.1 \[kg\] | 165.9 \[cm\] | 29.46647 \[kg/m^2\] | Z68.29      | Overweight     |
|  52 |  83.9 \[kg\] | 170.4 \[cm\] | 28.89501 \[kg/m^2\] | Z68.28      | Overweight     |
|  31 | 136.3 \[kg\] | 180.9 \[cm\] | 41.65036 \[kg/m^2\] | Z68.41      | Obese          |
|  70 |  84.0 \[kg\] | 180.5 \[cm\] | 25.78249 \[kg/m^2\] | Z68.25      | Overweight     |
|  52 |  39.3 \[kg\] | 144.3 \[cm\] | 18.87382 \[kg/m^2\] | Z68.1       | Healthy Weight |
|  76 |  69.4 \[kg\] | 150.5 \[cm\] | 30.63984 \[kg/m^2\] | Z68.30      | Obese          |
|  32 |  87.2 \[kg\] | 177.1 \[cm\] | 27.80221 \[kg/m^2\] | Z68.27      | Overweight     |
|  52 |  55.8 \[kg\] | 160.7 \[cm\] | 21.60740 \[kg/m^2\] | Z68.21      | Healthy Weight |

<br> <br>

------------------------------------------------------------------------

## NLM’s MedlinePlus Connect API

``` r
rx <- codex_medline(code_title = "Chantix 0.5 MG Oral Tablet", 
                    code_system = "rxcui")

rx |> dplyr::mutate(dplyr::across(everything(), as.character)) |> 
      tidyr::pivot_longer(cols = dplyr::everything()) |> 
      gluedown::md_table()
```

| name                | value                                                                                                                                                                                                                                           |
|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| updated             | 2023-01-16 16:23:23                                                                                                                                                                                                                             |
| entry_title         | Varenicline                                                                                                                                                                                                                                     |
| source              | U.S. National Library of Medicine                                                                                                                                                                                                               |
| search_description  | , RXNORM, Chantix 0.5 MG Oral Tablet, PAT                                                                                                                                                                                                       |
| results_description | MedlinePlus Connect results for RXCUI                                                                                                                                                                                                           |
| entry_link          | <https://medlineplus.gov/druginfo/meds/a606024.html?utm_source=mplusconnect&utm_medium=service>                                                                                                                                                 |
| entry_summary       | Varenicline is used along with education and counseling to help people stop smoking. Varenicline is in a class of medications called smoking cessation aids. It works by blocking the pleasant effects of nicotine (from smoking) on the brain. |

<br> <br>

------------------------------------------------------------------------

## Medicare Fee-for-Service Comprehensive Error Rate Testing API

``` r
codex_cert(hcpcs = "81595", 
           decision = "Disagree") |> 
  dplyr::select(-type_of_bill, 
                -drg, 
                -claim_control_number) |> 
  gluedown::md_table()
```

| year | part       | hcpcs_procedure_code | provider_type                               | review_decision | error_code                 |
|-----:|:-----------|:---------------------|:--------------------------------------------|:----------------|:---------------------------|
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |
| 2021 | 1\. Part B | 81595                | Clinical Laboratory (Billing Independently) | Disagree        | Insufficient Documentation |

<br> <br>

------------------------------------------------------------------------

## NCCI Procedure-to-Procedure Edits (PTP) API

``` r
codex_ptp(column_1 = "29000") |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale            |
|:-------------------|:-------------|:---------|:---------|:---------------|:--------------|:-------------------|:------------------------------|
| 2022-10-01         | DME Services | 29000    | 29010    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29015    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29020    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29025    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29035    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29040    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |

<br>

``` r
codex_ptp(column_2 = "L1951") |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale            |
|:-------------------|:-------------|:---------|:---------|:---------------|:--------------|:-------------------|:------------------------------|
| 2022-10-01         | DME Services | 29305    | L1951    | 2013-04-01     | NA            | 1                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29325    | L1951    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29345    | L1951    | 2013-04-01     | NA            | 1                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29355    | L1951    | 2013-04-01     | NA            | 1                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29358    | L1951    | 2013-04-01     | NA            | 1                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29365    | L1951    | 2013-04-01     | NA            | 1                  | Mutually exclusive procedures |

<br>

``` r
codex_ptp(category = "DME Services") |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale            |
|:-------------------|:-------------|:---------|:---------|:---------------|:--------------|:-------------------|:------------------------------|
| 2022-10-01         | DME Services | 29000    | 29010    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29015    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29020    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29025    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29035    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29040    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |

<br>

``` r
codex_ptp(modifier_indicator = "0") |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale            |
|:-------------------|:-------------|:---------|:---------|:---------------|:--------------|:-------------------|:------------------------------|
| 2022-10-01         | DME Services | 29000    | 29010    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29015    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29020    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29025    | 2013-04-01     | 2014-12-31    | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29035    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000    | 29040    | 2013-04-01     | NA            | 0                  | Mutually exclusive procedures |

<br>

``` r
codex_ptp(column_1 = "29000", modifier_indicator = "1") |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category                     | column_1 | column_2 | effective_date | deletion_date | modifier_indicator | ptp_edit_rationale                             |
|:-------------------|:-----------------------------|:---------|:---------|:---------------|:--------------|:-------------------|:-----------------------------------------------|
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0213T    | 2010-10-01     | NA            | 1                  | Misuse of column two code with column one code |
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0214T    | 2015-10-01     | NA            | 1                  | Misuse of column two code with column one code |
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0215T    | 2015-10-01     | NA            | 1                  | Misuse of column two code with column one code |
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0216T    | 2010-10-01     | NA            | 1                  | Misuse of column two code with column one code |
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0217T    | 2015-10-01     | NA            | 1                  | Misuse of column two code with column one code |
| 2022-10-01         | Outpatient Hospital Services | 29000    | 0218T    | 2015-10-01     | NA            | 1                  | Misuse of column two code with column one code |

<br>

``` r
codex_ptp(ptp_edit_rationale = "Mutually exclusive procedures", 
          explain = TRUE) |> 
  dplyr::select(-record_number) |> 
  head() |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | hcpcs_comprehensive | hcpcs_component | effective_date | deletion_date | modifier_use | reasoning                     |
|:-------------------|:-------------|:--------------------|:----------------|:---------------|:--------------|:-------------|:------------------------------|
| 2022-10-01         | DME Services | 29000               | 29010           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000               | 29015           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000               | 29020           | 2013-04-01     | 2014-12-31    | Allowed (0)  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000               | 29025           | 2013-04-01     | 2014-12-31    | Allowed (0)  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000               | 29035           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |
| 2022-10-01         | DME Services | 29000               | 29040           | 2013-04-01     | NA            | Allowed (0)  | Mutually exclusive procedures |

<br> <br>

------------------------------------------------------------------------

## NCCI Medically Unlikely Edits (MUEs) API

``` r
codex_mue(category = "Practitioner Services", 
          hcpcscpt_code = "G0121") |> 
  dplyr::select(-record_number) |> 
  dplyr::arrange(desc(quarter_begin_date)) |> 
  gluedown::md_table()
```

| quarter_begin_date | category              | hcpcs_code | mue_value | mue_rationale          |
|:-------------------|:----------------------|:-----------|----------:|:-----------------------|
| 2022-10-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2022-07-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2022-04-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2022-01-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2021-10-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2021-07-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2021-04-01         | practitioner services | G0121      |         1 | Anatomic Consideration |
| 2021-01-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2020-10-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2020-07-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2020-04-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2020-01-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2019-10-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2019-07-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2019-04-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2019-01-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2018-10-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2018-07-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2018-04-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |
| 2018-01-01         | Practitioner Services | G0121      |         1 | Anatomic Consideration |

<br>

``` r
codex_mue(category = "DME Services", 
          mue_value = "2", 
          mue_rationale = "Code Descriptor / CPT Instruction") |> 
  dplyr::select(-record_number) |> 
  dplyr::filter(quarter_begin_date >= as.Date("2022-10-01")) |> 
  dplyr::arrange(desc(quarter_begin_date)) |> 
  gluedown::md_table()
```

| quarter_begin_date | category     | hcpcs_code | mue_value | mue_rationale                     |
|:-------------------|:-------------|:-----------|----------:|:----------------------------------|
| 2022-10-01         | DME Services | A4635      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | A4636      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0111      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0113      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0116      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0117      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0154      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0157      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0159      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0175      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0310      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0952      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0959      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0960      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0961      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0973      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E0974      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E1020      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2205      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2206      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2207      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2211      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2212      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2213      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2216      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2218      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2220      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2224      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2227      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2228      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2358      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2359      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2361      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2363      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2365      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2368      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2369      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2370      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2371      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2381      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2382      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2383      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2386      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2388      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2390      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | E2619      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0051      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0065      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0069      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0070      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0071      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0072      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0077      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | K0733      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L1070      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L1080      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L1100      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L1110      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L2182      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L2184      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L2186      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L3600      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L3610      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L3620      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L3630      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L5280      |         2 | Code Descriptor / CPT Instruction |
| 2022-10-01         | DME Services | L5341      |         2 | Code Descriptor / CPT Instruction |

<br>

------------------------------------------------------------------------
