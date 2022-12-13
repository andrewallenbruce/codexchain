
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

## Usage

``` r
library(codexchain)
```

<br>

## NLM’s ICD-10-CM 2023 API

Return the seven ICD-10-CM codes beginning with “A15”

``` r
codex_icd10(code = "A15") |> gluedown::md_table()
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
codex_icd10(term = "tuber", limit = 20) |> gluedown::md_table()
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
codex_icd10(term = "pleurisy") |> gluedown::md_table()
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
codex_icd10(code = "Z", limit = 10) |> gluedown::md_table()
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
codex_icd10(code = "z", field = "code", limit = 10) |> gluedown::md_table()
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

<br>

### BMI Coding Example

``` r
NHANES::NHANES |> 
  janitor::clean_names() |> 
  dplyr::select(age, weight, height, bmi, bmi_who) |> 
  dplyr::filter(age > 20) |> 
  dplyr::slice(1:100) |> 
  dplyr::arrange(age) |> 
  gluedown::md_table()
```

| age | weight | height |   bmi | bmi_who      |
|----:|-------:|-------:|------:|:-------------|
|  21 |  103.5 |  166.5 | 37.33 | 30.0_plus    |
|  21 |  103.5 |  166.5 | 37.33 | 30.0_plus    |
|  25 |   86.3 |  178.6 | 27.06 | 25.0_to_29.9 |
|  26 |   64.9 |  175.8 | 21.00 | 18.5_to_24.9 |
|  26 |   67.9 |  162.0 | 25.87 | 25.0_to_29.9 |
|  26 |   67.9 |  162.0 | 25.87 | 25.0_to_29.9 |
|  26 |   67.9 |  162.0 | 25.87 | 25.0_to_29.9 |
|  26 |   66.7 |  171.0 | 22.81 | 18.5_to_24.9 |
|  27 |   69.9 |  165.5 | 25.52 | 25.0_to_29.9 |
|  28 |   78.2 |  175.3 | 25.45 | 25.0_to_29.9 |
|  28 |  134.3 |  169.6 | 46.69 | 30.0_plus    |
|  29 |   87.8 |  164.4 | 32.49 | 30.0_plus    |
|  29 |   87.8 |  164.4 | 32.49 | 30.0_plus    |
|  29 |   87.8 |  164.4 | 32.49 | 30.0_plus    |
|  29 |   94.1 |  174.5 | 30.90 | 30.0_plus    |
|  29 |   94.1 |  174.5 | 30.90 | 30.0_plus    |
|  29 |   94.1 |  174.5 | 30.90 | 30.0_plus    |
|  29 |   94.1 |  174.5 | 30.90 | 30.0_plus    |
|  29 |   92.3 |  181.8 | 27.93 | 25.0_to_29.9 |
|  30 |  125.8 |  186.2 | 36.28 | 30.0_plus    |
|  30 |   88.4 |  175.8 | 28.60 | 25.0_to_29.9 |
|  30 |   54.0 |  162.4 | 20.47 | 18.5_to_24.9 |
|  30 |   54.0 |  162.4 | 20.47 | 18.5_to_24.9 |
|  30 |   54.0 |  162.4 | 20.47 | 18.5_to_24.9 |
|  31 |   64.9 |  149.7 | 28.96 | 25.0_to_29.9 |
|  31 |   64.9 |  149.7 | 28.96 | 25.0_to_29.9 |
|  31 |  129.3 |  162.6 | 48.91 | 30.0_plus    |
|  32 |   60.3 |  173.0 | 20.15 | 18.5_to_24.9 |
|  33 |   93.8 |  181.3 | 28.54 | 25.0_to_29.9 |
|  34 |   87.4 |  164.7 | 32.22 | 30.0_plus    |
|  34 |   87.4 |  164.7 | 32.22 | 30.0_plus    |
|  34 |   87.4 |  164.7 | 32.22 | 30.0_plus    |
|  34 |   76.6 |  173.8 | 25.36 | 25.0_to_29.9 |
|  34 |   76.6 |  173.8 | 25.36 | 25.0_to_29.9 |
|  34 |   76.6 |  173.8 | 25.36 | 25.0_to_29.9 |
|  35 |   58.8 |  169.8 | 20.39 | 18.5_to_24.9 |
|  36 |   79.2 |  174.7 | 25.95 | 25.0_to_29.9 |
|  37 |   50.7 |  154.8 | 21.16 | 18.5_to_24.9 |
|  38 |  117.3 |  180.9 | 35.84 | 30.0_plus    |
|  38 |   78.9 |  174.5 | 25.91 | 25.0_to_29.9 |
|  38 |   78.9 |  174.5 | 25.91 | 25.0_to_29.9 |
|  38 |   78.9 |  174.5 | 25.91 | 25.0_to_29.9 |
|  41 |   91.1 |  176.9 | 29.11 | 25.0_to_29.9 |
|  43 |  136.3 |  185.0 | 39.82 | 30.0_plus    |
|  43 |  136.3 |  185.0 | 39.82 | 30.0_plus    |
|  44 |   86.5 |  165.9 | 31.43 | 30.0_plus    |
|  44 |   86.5 |  165.9 | 31.43 | 30.0_plus    |
|  44 |   84.6 |  182.0 | 25.54 | 25.0_to_29.9 |
|  44 |   57.8 |  155.1 | 24.03 | 18.5_to_24.9 |
|  44 |   57.8 |  155.1 | 24.03 | 18.5_to_24.9 |
|  44 |   57.8 |  155.1 | 24.03 | 18.5_to_24.9 |
|  44 |   57.8 |  155.1 | 24.03 | 18.5_to_24.9 |
|  45 |   75.7 |  166.7 | 27.24 | 25.0_to_29.9 |
|  45 |   75.7 |  166.7 | 27.24 | 25.0_to_29.9 |
|  45 |   75.7 |  166.7 | 27.24 | 25.0_to_29.9 |
|  46 |   60.0 |  148.2 | 27.32 | 25.0_to_29.9 |
|  49 |   86.7 |  168.4 | 30.57 | 30.0_plus    |
|  49 |   87.6 |  173.4 | 29.13 | 25.0_to_29.9 |
|  50 |   84.1 |  177.8 | 26.60 | 25.0_to_29.9 |
|  50 |   85.2 |  169.0 | 29.83 | 25.0_to_29.9 |
|  50 |   97.9 |  155.1 | 40.70 | 30.0_plus    |
|  50 |   87.2 |  171.5 | 29.65 | 25.0_to_29.9 |
|  51 |   82.1 |  163.8 | 30.60 | 30.0_plus    |
|  51 |   82.1 |  163.8 | 30.60 | 30.0_plus    |
|  54 |   74.7 |  169.4 | 26.03 | 25.0_to_29.9 |
|  54 |  113.9 |  177.1 | 36.32 | 30.0_plus    |
|  54 |  113.9 |  177.1 | 36.32 | 30.0_plus    |
|  54 |   53.9 |  160.1 | 21.03 | 18.5_to_24.9 |
|  54 |   53.9 |  160.1 | 21.03 | 18.5_to_24.9 |
|  54 |   53.9 |  160.1 | 21.03 | 18.5_to_24.9 |
|  56 |   57.5 |  170.7 | 19.73 | 18.5_to_24.9 |
|  56 |   57.5 |  170.7 | 19.73 | 18.5_to_24.9 |
|  56 |   72.7 |  170.6 | 24.98 | 25.0_to_29.9 |
|  56 |   67.8 |  154.3 | 28.48 | 25.0_to_29.9 |
|  56 |   67.8 |  154.3 | 28.48 | 25.0_to_29.9 |
|  57 |   51.0 |  157.1 | 20.66 | 18.5_to_24.9 |
|  58 |   78.4 |  181.9 | 23.69 | 18.5_to_24.9 |
|  58 |   57.5 |  148.1 | 26.22 | 25.0_to_29.9 |
|  58 |  106.0 |  167.2 | 37.92 | 30.0_plus    |
|  58 |  106.0 |  167.2 | 37.92 | 30.0_plus    |
|  58 |  106.0 |  167.2 | 37.92 | 30.0_plus    |
|  58 |   94.0 |  179.2 | 29.27 | 25.0_to_29.9 |
|  59 |   54.3 |  145.1 | 25.79 | 25.0_to_29.9 |
|  59 |   54.3 |  145.1 | 25.79 | 25.0_to_29.9 |
|  60 |   74.6 |  169.9 | 25.84 | 25.0_to_29.9 |
|  61 |   61.8 |  147.6 | 28.37 | 25.0_to_29.9 |
|  63 |   75.2 |  150.6 | 33.16 | 30.0_plus    |
|  63 |   87.8 |  178.8 | 27.46 | 25.0_to_29.9 |
|  64 |   62.8 |  152.0 | 27.18 | 25.0_to_29.9 |
|  66 |   68.0 |  169.5 | 23.67 | 18.5_to_24.9 |
|  66 |   68.9 |  155.2 | 28.60 | 25.0_to_29.9 |
|  66 |   68.9 |  155.2 | 28.60 | 25.0_to_29.9 |
|  70 |   86.0 |  145.8 | 40.46 | 30.0_plus    |
|  76 |   85.2 |  163.4 | 31.91 | 30.0_plus    |
|  78 |   51.6 |  151.0 | 22.63 | 18.5_to_24.9 |
|  80 |   66.9 |  156.7 | 27.25 | 25.0_to_29.9 |
|  80 |   66.9 |  156.7 | 27.25 | 25.0_to_29.9 |
|  80 |   51.4 |  169.6 | 17.87 | 12.0_18.5    |
|  80 |   95.5 |  167.5 | 34.04 | 30.0_plus    |
|  80 |   82.8 |  168.0 | 29.34 | 25.0_to_29.9 |

<br>

``` r
codex_icd10(term = "bmi adult", limit = 30) |> gluedown::md_table()
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

## NLM’s MedlinePlus Connect API

``` r
rx <- codex_medline(code_title = "Chantix 0.5 MG Oral Tablet", 
              code_system = "rxcui")

rx |> 
  dplyr::mutate(entry_summary = stringr::str_wrap(entry_summary)) |> 
  dplyr::mutate(dplyr::across(everything(), as.character)) |> 
  tidyr::pivot_longer(cols = dplyr::everything()) |> 
  gluedown::md_table()
```

| name                | value                                                                                           |
|:--------------------|:------------------------------------------------------------------------------------------------|
| updated             | 2022-12-13 22:48:07                                                                             |
| entry_title         | Varenicline                                                                                     |
| source              | U.S. National Library of Medicine                                                               |
| search_description  | , RXNORM, Chantix 0.5 MG Oral Tablet, PAT                                                       |
| results_description | MedlinePlus Connect results for RXCUI                                                           |
| entry_link          | <https://medlineplus.gov/druginfo/meds/a606024.html?utm_source=mplusconnect&utm_medium=service> |
| entry_summary       | Varenicline is used along with education and counseling to help people stop                     |

smoking. Varenicline is in a class of medications called smoking
cessation aids. It works by blocking the pleasant effects of nicotine
(from smoking) on the brain. \|

``` r
sno <- codex_medline(code = "41381004", 
              code_title = "Pneumonia due to Pseudomonas", 
              code_system = "snomed")

sno |> 
  dplyr::mutate(entry_summary = stringr::str_wrap(entry_summary)) |> 
  dplyr::mutate(dplyr::across(everything(), as.character)) |> 
  tidyr::pivot_longer(cols = dplyr::everything()) |> 
  gluedown::md_table()
```

| name                | value                                                                               |
|:--------------------|:------------------------------------------------------------------------------------|
| updated             | 2022-12-13 22:48:07                                                                 |
| entry_title         | Pneumonia                                                                           |
| source              | U.S. National Library of Medicine                                                   |
| search_description  | 41381004, SNOMEDCT, Pneumonia due to Pseudomonas, PAT                               |
| results_description | MedlinePlus Connect results for SNOMED CT 41381004                                  |
| entry_link          | <https://medlineplus.gov/pneumonia.html?utm_source=mplusconnect&utm_medium=service> |
| entry_summary       | What is pneumonia? Pneumonia is an infection in one or both of the lungs. It        |

causes the air sacs of the lungs to fill up with fluid or pus. It can
range from mild to severe, depending on the type of germ causing the
infection, your age, and your overall health. What causes pneumonia?
Bacterial, viral, and fungal infections can cause pneumonia. Bacteria
are the most common cause. Bacterial pneumonia can occur on its own. It
can also develop after you’ve had certain viral infections such as a
cold or the flu. Several different types of bacteria can cause
pneumonia, including: • Streptococcus pneumoniae • Legionella
pneumophila; this pneumonia is often called Legionnaires’ disease •
Mycoplasma pneumoniae • Chlamydia pneumoniae • Haemophilus influenzae
Viruses that infect the respiratory tract may cause pneumonia. Viral
pneumonia is often mild and goes away on its own within a few weeks. But
sometimes it is serious enough that you need to get treatment in a
hospital. If you have viral pneumonia, you are at risk of also getting
bacterial pneumonia. The different viruses that can cause pneumonia
include: • Respiratory syncytial virus (RSV) • Some common cold and flu
viruses • SARS-CoV-2, the virus that causes COVID-19 Fungal pneumonia is
more common in people who have chronic health problems or weakened
immune systems. Some of the types include: • Pneumocystis pneumonia
(PCP) • Coccidioidomycosis, which causes valley fever • Histoplasmosis •
Cryptococcus Who is at risk for pneumonia? Anyone can get pneumonia, but
certain factors can increase your risk: • Age; the risk is higher for
children who are age 2 and under and adults age 65 and older • Exposure
to certain chemicals, pollutants, or toxic fumes • Lifestyle habits,
such as smoking, heavy alcohol use, and malnourishment • Being in a
hospital, especially if you are in the ICU. Being sedated and/or on a
ventilator raises the risk even more. • Having a lung disease • Having a
weakened immune system • Have trouble coughing or swallowing, from a
stroke or other condition • Recently being sick with a cold or the flu
What are the symptoms of pneumonia? The symptoms of pneumonia can range
from mild to severe and include: • Fever • Chills • Cough, usually with
phlegm (a slimy substance from deep in your lungs) • Shortness of breath
• Chest pain when you breathe or cough • Nausea and/or vomiting •
Diarrhea The symptoms can vary for different groups. Newborns and
infants may not show any signs of the infection. Others may vomit and
have a fever and cough. They might seem sick, with no energy, or be
restless. Older adults and people who have serious illnesses or weak
immune systems may have fewer and milder symptoms. They may even have a
lower than normal temperature. Older adults who have pneumonia sometimes
have sudden changes in mental awareness. What other problems can
pneumonia cause? Sometimes pneumonia can cause serious complications
such as: • Bacteremia, which happens when the bacteria move into the
bloodstream. It is serious and can lead to septic shock. • Lung
abscesses, which are collections of pus in cavities of the lungs •
Pleural disorders, which are conditions that affect the pleura. The
pleura is the tissue that covers the outside of the lungs and lines the
inside of your chest cavity. • Kidney failure • Respiratory failure How
is pneumonia diagnosed? Sometimes pneumonia can be hard to diagnose.
This is because it can cause some of the same symptoms as a cold or the
flu. It may take time for you to realize that you have a more serious
condition. Your health care provider may use many tools to make a
diagnosis: • A medical history, which includes asking about your
symptoms • A physical exam, including listening to your lungs with a
stethoscope • Various tests, such as • A chest x-ray • Blood tests such
as a complete blood count (CBC) to see if your immune system is actively
fighting an infection • A Blood culture to find out whether you have a
bacterial infection that has spread to your bloodstream If you are in
the hospital, have serious symptoms, are older, or have other health
problems, you may also have more tests, such as: • Sputum test, which
checks for bacteria in a sample of your sputum (spit) or phlegm (slimy
substance from deep in your lungs). • Chest CT scan to see how much of
your lungs is affected. It may also show if you have complications such
as lung abscesses or pleural effusions. • Pleural fluid culture, which
checks for bacteria in a fluid sample that was taken from the pleural
space • Pulse oximetry or blood oxygen level test, to check how much
oxygen is in your blood • Bronchoscopy, a procedure used to look inside
your lungs’ airways What are the treatments for pneumonia? Treatment for
pneumonia depends on the type of pneumonia, which germ is causing it,
and how severe it is: • Antibiotics treat bacterial pneumonia and some
types of fungal pneumonia. They do not work for viral pneumonia. • In
some cases, your provider may prescribe antiviral medicines for viral
pneumonia • Antifungal medicines treat other types of fungal pneumonia
You may need to be treated in a hospital if your symptoms are severe or
if you are at risk for complications. While there, you may get
additional treatments. For example, if your blood oxygen level is low,
you may receive oxygen therapy. It may take time to recover from
pneumonia. Some people feel better within a week. For other people, it
can take a month or more. Can pneumonia be prevented? Vaccines can help
prevent pneumonia caused by pneumococcal bacteria or the flu virus.
Having good hygiene, not smoking, and having a healthy lifestyle may
also help prevent pneumonia. NIH: National Heart, Lung, and Blood
Institute \|

<br>

## Medicare Fee-for-Service Comprehensive Error Rate Testing API

``` r
codex_cert(hcpcs = "92002", 
           decision = "Disagree") |> 
  dplyr::select(-type_of_bill, -drg) |> 
           gluedown::md_table()
```

| year | claim_control_number | part       | hcpcs_procedure_code | provider_type | review_decision | error_code                 |
|-----:|---------------------:|:-----------|:---------------------|:--------------|:----------------|:---------------------------|
| 2021 |              2134770 | 1\. Part B | 92002                | Optometry     | Disagree        | Other                      |
| 2021 |              2136243 | 1\. Part B | 92002                | Ophthalmology | Disagree        | Insufficient Documentation |
| 2021 |              2139556 | 1\. Part B | 92002                | Optometry     | Disagree        | Incorrect Coding           |
| 2021 |              2142814 | 1\. Part B | 92002                | Ophthalmology | Disagree        | Incorrect Coding           |
| 2021 |              2139587 | 1\. Part B | 92002                | Ophthalmology | Disagree        | Incorrect Coding           |
| 2021 |              2146877 | 1\. Part B | 92002                | Optometry     | Disagree        | Incorrect Coding           |
| 2021 |              2145036 | 1\. Part B | 92002                | Ophthalmology | Disagree        | Incorrect Coding           |
| 2021 |              2145815 | 1\. Part B | 92002                | Optometry     | Disagree        | Incorrect Coding           |

<br>

## NCCI Procedure-to-Procedure Edits (PTP) API

``` r
codex_ptp() |> 
  head() |> 
  dplyr::select(-record_number) |> 
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
codex_ptp(explain = TRUE) |> 
  head() |> 
  dplyr::select(-record_number) |> 
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

<br>

## NCCI Medically Unlikely Edits (MUEs) API

``` r
codex_mue() |> 
     head() |> 
     gluedown::md_table()
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
