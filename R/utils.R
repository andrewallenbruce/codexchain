#' Calculate Number of Days Between Two Dates ------------------------------
#' Note: Calculation includes end date in the sum (see example)
#' @param df data frame containing date columns
#' @param start column containing date(s) prior to end_date column
#' @param end column containing date(s) after start_date column
#' @param colname desired column name of output; default is "age"
#' @return A [tibble][tibble::tibble-package] with a named column
#'    containing the calculated number of days.
#' @examples
#' date_ex <- tibble::tibble(x = seq.Date(as.Date("2021-01-01"),
#'                           by = "month", length.out = 3),
#'                           y = seq.Date(as.Date("2022-01-01"),
#'                           by = "month", length.out = 3))
#' age_days(df = date_ex,
#'          start = x,
#'          end = y)
#'
#' date_ex |>
#' age_days(x, y, colname = "days_between_x_y")
#'
#' date_ex |>
#' age_days(start = x,
#' end = lubridate::today(),
#' colname = "days_since_x")
#'
#' date_ex |>
#' age_days(x, y, "days_between_x_y") |>
#' age_days(x, lubridate::today(), "days_since_x") |>
#' age_days(y, lubridate::today(), colname = "days_since_y")
#' @autoglobal
#' @noRd
age_days <- function(df,
                     start,
                     end,
                     colname = "age") {

  results <- df |>
    dplyr::mutate(start = as.Date({{ start }},
                                  "%yyyy-%mm-%dd",
                                  tz = "EST"),
                  end = as.Date({{ end }},
                                "%yyyy-%mm-%dd",
                                tz = "EST")) |>
    dplyr::mutate("{colname}" := ((as.numeric(
      lubridate::days(end) - lubridate::days(start),
      "hours") / 24) + 1)) |>
    dplyr::select(!c(end, start))

  return(results)
}

#' Calculate Number of Days Between a Date and Today -----------------------
#' @param df data frame containing date columns
#' @param start date column
#' @param colname desired column name of output
#' @return data frame with a column containing the number of days
#'    calculated.
#' @examples
#' ex <- data.frame(x = c("1992-02-05",
#'                        "2020-01-04",
#'                        "1996-05-01",
#'                        "2020-05-01",
#'                        "1996-02-04"))
#'
#' days_today(df = ex, start = x)
#'
#' ex |> days_today(x)
#' @autoglobal
#' @noRd
days_today <- function(df, start, colname = "age") {

  results <- df |>
    dplyr::mutate(int = lubridate::interval({{ start }},
                                            lubridate::today()),
                  secs = lubridate::int_length(int),
                  mins = secs/60,
                  hrs = mins/60,
                  "{colname}" := abs(hrs/24)) |>
    dplyr::select(!c(int, secs, mins, hrs))

  return(results)

}

#' Format US ZIP codes -----------------------------------------------------
#' @param zip Nine-digit US ZIP code
#' @return ZIP code, hyphenated for ZIP+4 or 5-digit ZIP.
#' @examples
#' format_zipcode(123456789)
#' format_zipcode(12345)
#' @autoglobal
#' @noRd
format_zipcode <- function(zip) {
  zip <- as.character(zip)
  if (stringr::str_detect(zip, "^[[:digit:]]{9}$") == TRUE) {
    zip <- paste0(stringr::str_sub(zip, 1, 5), "-",
                  stringr::str_sub(zip, 6, 9))
    return(zip)} else {return(zip)}
}

#' Remove NULL elements from vector ----------------------------------------
#' @autoglobal
#' @noRd
remove_null <- function(l) {Filter(Negate(is.null), l)}

#' Clean up credentials ----------------------------------------------------
#' @param x Character vector of credentials
#' @return List of cleaned character vectors, with one list element per element
#'   of `x`
#' @autoglobal
#' @noRd
clean_credentials <- function(x) {
  if (!is.character(x)) {stop("x must be a character vector")}
  out <- gsub("\\.", "", x)
  out <- stringr::str_split(out, "[,\\s;]+", simplify = FALSE)
  return(out)
}

#' Create full address -----------------------------------------------------
#' @param df data frame
#' @param address_1 Quoted column containing first-street address
#' @param address_2 Quoted column containing second-street address
#' @param city Quoted column containing city
#' @param state Quoted column containing two-letter state abbreviation
#' @param postal_code Quoted column containing postal codes
#' @return Character vector containing full one-line address
#' @autoglobal
#' @noRd
full_address <- function(df,
                         address_1,
                         address_2,
                         city,
                         state,
                         postal_code) {

  stringr::str_c(stringr::str_trim(df[[address_1]], "both"),
                 ifelse(df[[address_2]] == "", "", " "),
                 stringr::str_trim(df[[address_2]], "both"), ", ",
                 stringr::str_trim(df[[city]], "both"), ", ",
                 stringr::str_trim(df[[state]], "both"), " ",
                 stringr::str_trim(df[[postal_code]], "both"))
}

#' luhn check npis ---------------------------------------------------------
#' @description checks NPIs against the Luhn algorithm for
#' compliance with the CMS requirements stated in the linked PDF below.
#'
#' # Requirements for NPI Check Digit
#'
#' The National Provider Identifier (NPI) check digit is calculated using
#' the Luhn formula for computing the modulus 10 “double-add-double” check
#' digit. This algorithm is recognized as an ISO standard and is the specified
#' check digit algorithm to be used for the card issuer identifier on a
#' standard health identification card.
#'
#' When an NPI is used as a card issuer identifier on a standard health
#' identification card, it is preceded by the prefix `80840`, in which `80`
#' indicates health applications and `840` indicates the United States.
#'
#' The prefix is required only when the NPI is used as a card issuer
#' identifier. However, in order that any NPI could be used as a card issuer
#' identifier on a standard health identification card, the check digit will
#' always be calculated as if the prefix is present. This is accomplished by
#' adding the constant `24` in step 2 of the check digit calculation (as shown
#' in the second example below) when the NPI is used without the prefix.
#'
#' ## Example NPI Check Digit Calculation (Card Issuer Identifier)
#'
#' Assume that the NPI is `123456789`. If used as a card issuer identifier on
#' a standard health identification card, the full number would be
#' `80840123456789`. Using the Luhn formula on the identifier portion, the
#' check digit is calculated as follows:
#'
#' 1. Card issuer identifier without check digit: `80840123456789`
#' 2. Double the value of alternate digits, beginning with the rightmost
#'    digit: `0 8 2 6 10 14 18`
#' 3. Add the individual digits of products of doubling, plus unaffected
#'    digits:
#'    `8 + 0 + 8 + 8 + 0 + 2 + 2 + 6 + 4 + 1 + 0 + 6 + 1 + 4 + 8 + 1 + 8 = 67`
#' 4. Subtract from next higher number ending in zero: `70 – 67 = 3`
#' 5. The check digit equals 3, thus the card issuer identifier with check
#'    digit is **80840**123456789**3**.
#'
#' ## Example NPI Check Digit Calculation (without Prefix)
#'
#' Assume that the NPI is `123456789`. Using the Luhn formula on the
#' identifier portion, the check digit is calculated as follows:
#'
#' 1. NPI without check digit: `123456789`
#' 2. Double the value of alternate digits, beginning with the rightmost
#'    digit: `2 6 10 14 18`
#' 3. Add constant `24`, to account for the `80840` prefix that would be
#'    present on a card issuer identifier, plus the individual digits of
#'    products of doubling, plus unaffected digits:
#'    `24 + 2 + 2 + 6 + 4 + 1 + 0 + 6 + 1 + 4 + 8 + 1 + 8 = 67`
#' 4. Subtract from next higher number ending in zero: `70 – 67 = 3`
#' 5. The check digit equals **3**, thus the NPI with check digit
#'    is 123456789**3**.
#'
#' ## Links
#'  * [The Luhn Algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm)
#'  * [CMS NPI Standard](https://www.cms.gov/Regulations-and-Guidance/Administrative-Simplification/NationalProvIdentStand/Downloads/NPIcheckdigit.pdf)
#'
#' @param npi 10-digit National Provider Identifier (NPI).
#' @return boolean, `TRUE` or `FALSE`
#' @examples
#' # Valid NPI:
#' provider_luhn(npi = 1528060837)
#'
#' # Quoted NPIs are valid:
#' provider_luhn(npi = "1528060837")
#'
#' # Invalid NPI (per Luhn algorithm):
#' provider_luhn(npi = 1234567891)
#'
#' \dontrun{
#' # NPIs with less than 10 digits throw an error:
#' provider_luhn(npi = 123456789)
#'
#' # Inputting letters will throw an error, quoted or not:
#' provider_luhn(npi = abcdefghij)
#' provider_luhn(npi = "abcdefghij")
#' }
#' @autoglobal
#' @noRd
luhn_check <- function(npi = NULL) {

  # Number of digits should be 10
  attempt::stop_if_not(nchar(npi) == 10,
                       msg = c("NPIs must have 10 digits.
  Provided NPI has ", nchar(npi), " digits."))

  # Return FALSE if not a number
  if (!grepl("^[[:digit:]]+$", npi)) {return(FALSE)}

  # Strip whitespace
  npi <- gsub(pattern = " ", replacement = "", npi)

  # Paste 80840 to each NPI number, per CMS documentation
  npi <- paste0("80840", npi)

  # Split string, Convert to list and reverse
  npi <- unlist(strsplit(npi, ""))
  npi <- npi[length(npi):1]
  to_replace <- seq(2, length(npi), 2)
  npi[to_replace] <- as.numeric(npi[to_replace]) * 2

  # Convert to numeric
  npi <- as.numeric(npi)

  # Must be a single digit, any that are > 9, subtract 9
  npi <- ifelse(npi > 9, npi - 9, npi)

  # Check if the sum divides by 10
  ((sum(npi) %% 10) == 0)
}

#' param_format ------------------------------------------------------------
#' @param param API parameter
#' @param arg API function arg
#' @return formatted API filters
#' @autoglobal
#' @noRd
param_format <- function(param, arg) {
  if (is.null(arg)) {param <- NULL} else {
    paste0("filter[", param, "]=", arg, "&")}}

#' param_space --------------------------------------------------------------
#' Some API parameters have spaces, these must be converted to "%20".
#' @param param parameter with a space
#' @return parameter formatted with "%20" in lieu of a space
#' @autoglobal
#' @noRd
param_space <- function(param) {gsub(" ", "%20", param)}

#' param_format ------------------------------------------------------------
#' @param param API parameter
#' @param arg API function arg
#' @return formatted API filters
#' @autoglobal
#' @noRd
medline_format <- function(param, arg) {
  if (is.null(arg)) {param <- NULL} else {
    x <- gsub(" ", "%20", arg)
    paste0(param, x, "&")}}


# assign_bmi_icd ----------------------------------------------------------
#' @param bmi body mass index
#' @return vector of assigned icd bmi codes
#' @autoglobal
#' @noRd
assign_bmi_icd <- function(bmi) {
  bmi <- as.numeric(bmi)
  dplyr::case_when(bmi >= 70 ~ "Z68.45",
                   bmi <= 19.99999 ~ "Z68.1",
                   bmi >= 20.0 & bmi <= 20.99999 ~ "Z68.20",
                   bmi >= 21.0 & bmi <= 21.99999 ~ "Z68.21",
                   bmi >= 22.0 & bmi <= 22.99999 ~ "Z68.22",
                   bmi >= 23.0 & bmi <= 23.99999 ~ "Z68.23",
                   bmi >= 24.0 & bmi <= 24.99999 ~ "Z68.24",
                   bmi >= 25.0 & bmi <= 25.99999 ~ "Z68.25",
                   bmi >= 26.0 & bmi <= 26.99999 ~ "Z68.26",
                   bmi >= 27.0 & bmi <= 27.99999 ~ "Z68.27",
                   bmi >= 28.0 & bmi <= 28.99999 ~ "Z68.28",
                   bmi >= 29.0 & bmi <= 29.99999 ~ "Z68.29",
                   bmi >= 30.0 & bmi <= 30.99999 ~ "Z68.30",
                   bmi >= 31.0 & bmi <= 31.99999 ~ "Z68.31",
                   bmi >= 32.0 & bmi <= 32.99999 ~ "Z68.32",
                   bmi >= 33.0 & bmi <= 33.99999 ~ "Z68.33",
                   bmi >= 34.0 & bmi <= 34.99999 ~ "Z68.34",
                   bmi >= 35.0 & bmi <= 35.99999 ~ "Z68.35",
                   bmi >= 36.0 & bmi <= 36.99999 ~ "Z68.36",
                   bmi >= 37.0 & bmi <= 37.99999 ~ "Z68.37",
                   bmi >= 38.0 & bmi <= 38.99999 ~ "Z68.38",
                   bmi >= 39.0 & bmi <= 39.99999 ~ "Z68.39",
                   bmi >= 40.0 & bmi <= 44.99999 ~ "Z68.41",
                   bmi >= 45.0 & bmi <= 49.99999 ~ "Z68.42",
                   bmi >= 50.0 & bmi <= 59.99999 ~ "Z68.43",
                   bmi >= 60.0 & bmi <= 69.99999 ~ "Z68.44",
                   TRUE ~ "ERROR")
}

# assign_bmi_status -------------------------------------------------------
#' @param bmi body mass index
#' @return vector of assigned bmi statuses
#' @autoglobal
#' @noRd
assign_bmi_status <- function(bmi) {
  bmi <- as.numeric(bmi)
  dplyr::case_when(bmi < 18.55 ~ "Underweight",
                   bmi >= 18.55 & bmi <= 24.99999 ~ "Healthy Weight",
                   bmi >= 25.04 & bmi <= 29.99999 ~ "Overweight",
                   bmi >= 30 ~ "Obese",
                   TRUE ~ "ERROR")
}

#' Calculate Body Mass Index (BMI) for Adults
#' @param weight weight in kg
#' @param height height in cm
#' @return vector of BMI values (kg/m2)
#' @examples
#' bmi_adult(70, 160)
#' @autoglobal
#' @noRd
bmi_adult <- function(weight, height) {

  weight <- units::set_units(weight, kg)
  height <- units::set_units(height, cm)

  units(height) <- units::make_units(m)

  bmi <- weight / (height ^ 2)

  units(bmi) <- units::make_units(kg/m^2)

  return(bmi)

}

#' Calculate Body Mass Index (BMI)
#' @param wt weight in kg
#' @param ht height in cm
#' @return vector of BMI values (kg/m2)
#' @examples
#' calc_bmi(wt = 70, ht = 160)
#' @autoglobal
#' @noRd
calc_bmi <- function(wt, ht) {
  wt / (ht / 100) ^ 2
  }

#' Convert Inches (in) to Centimeters (cm)
#' @param inch inches
#' @examples
#' conv_in_cm(1)
#' @autoglobal
#' @noRd
conv_in_cm <- function(inch) {inch * 2.54}

#' Convert Centimeters (cm) to Inches (in)
#' @param cent centimeters
#' @examples
#' conv_cm_in(2.54)
#' @autoglobal
#' @noRd
conv_cm_in <- function(cent) {cent / 2.54}

#' Convert Kilograms (kg) to Pounds (lbs)
#' @param kg kilograms
#' @examples
#' conv_kg_lbs(1)
#' @autoglobal
#' @noRd
conv_kg_lbs <- function(kg) {kg * 2.20462}

#' Convert Pounds (lbs) to Kilograms (kg)
#' @param lbs pounds
#' @examples
#' conv_lbs_kg(2.20462)
#' @autoglobal
#' @noRd
conv_lbs_kg <- function(lbs) {lbs / 2.20462}

#' Convert Kilograms (kg) to Ounces (oz)
#' @param kg kilograms
#' @examples
#' conv_kg_oz(1)
#' @autoglobal
#' @noRd
conv_kg_oz <- function(kg) {kg * 35.274}

#' Convert Ounces (oz) to Kilograms (kg)
#' @param oz ounces
#' @examples
#' oz2kg(2.20462)
#' @autoglobal
#' @noRd
conv_oz_kg <- function(oz) {oz / 35.274}

#' Percentile BMI for age for children
#' Based on tables from WHO:
#'    http://www.who.int/growthref/who2007_bmi_for_age/en/
#' @param age age in years
#' @param sex either `male` or `female`
#' @param height height
#' @param bmi bmi Optional, if specified, will calculate closest percentile
#'    and return in list as `percentile`
#' @param return_median just return the median expected value
#' @param ... parameters passed to `read_who_table()`
#' @examples
#' pct_bmi_for_age(age = 8, sex = "male")
#' pct_bmi_for_age(age = 8, bmi = 15, sex = "male")
#' @autoglobal
#' @noRd
pct_bmi_for_age <- function(age = NULL,
                            bmi = NULL,
                            sex = NULL,
                            height = NULL,
                            return_median = FALSE,
                            ...) {
  if (is.null(age)) {stop("Age required.")}
  if (length(age) == 1) {pct <- pct_for_age_generic(age = age,
                                                    value = bmi,
                                                    sex = sex,
                                                    variable = "bmi",
                                                    height = height,
                                                    ...)
  } else {
    tmp <- lapply(age, pct_bmi_for_age, sex = sex)
    pct <- data.frame(cbind("age" = age,
                            matrix(unlist(tmp),
                                   nrow = length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  if (return_median) {return(pct$P50)
  } else {
    return(pct)
  }
  return(pct)
}

#' Percentile height or weight for age for children
#'
#' This is the underlying function, the exposed functions are
#'    pct_weight_for_age() and pct_height_for_age()
#' Based on tables from WHO:
#'    http://www.who.int/childgrowth/standards/height_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param value height in kg. Optional, if specified, will calculate closest
#'    percentile and return in list as `percentile`
#' @param variable weight or height?
#' @param ... parameters passed to `read_who_table()`
#' @autoglobal
#' @noRd
pct_for_age_generic <- function(age = NULL,
                                value = NULL,
                                sex = NULL,
                                variable = "weight",
                                ...) {
  if (is.null(age) || is.null(sex)) {
    stop("Age and sex are required!")
  }
  if (variable == "height" & age > 19) {
    message("Sorry, height data currently only available for age <= 19 years.")
    return(NULL)
  }
  if (variable == "weight" & age > 10) {
    message("Sorry, currently only available for age <= 10 years.")
    return(NULL)
  }

  if (variable == "height") {
    type = ifelse(age >= 5.1, "hfa", "lhfa")
  } else if (variable == "bmi") {
    type = ifelse(age >= 5.1, "bmi", "bfa")
  } else {
    type <- "wfa"
  }

  dat <- read_who_table(sex = sex, age = age, type = type)
  tmp <- dat[which.min(abs(age - dat$age)),-(1:4)]
  pct <- as.list(tmp)
  if (!is.null(value)) {
    p <- c()
    for (i in seq(names(pct))) {
      p <- c(p, as.num(gsub("P", "", names(pct)[i])))
    }
    p[1] <- p[1]/10 # 0.1
    p[length(p)] <- p[length(p)]/10 # 99.9
    p_txt <- paste0("pct_", p)
    if (value >= max(tmp)) {
      message(paste0("Specified ", variable," >= 99.9th percentile!"))
      pct <- list(percentile = 99.9)
    }
    if (value <= min(tmp)) {
      message(paste0("Specified ", variable, " <= 0.1th percentile!"))
      pct <- list(percentile = 0.1)
    }
    if (is.null(pct$percentile)) {
      data <- data.frame(
        x = c(
          as.num(tmp[value <= as.num(tmp)][1]),
          tail(as.num(tmp[value > as.num(tmp)]),1)
        ),
        y = c(
          p[value <= as.num(tmp)][1],
          tail(p[value > as.num(tmp)],1)
        )
      )
      # linearly scale between two values
      fit <- lm(y~x, data)
      par <- coef(fit)
      pct <- list(percentile = round(as.num(par[1] + par[2]*value),1))
    }
  }
  return(pct)
}

#' Percentile height for age for children
#'
#' Based on tables from WHO: http://www.who.int/childgrowth/standards/height_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param height height in kg. Optional, if specified, will calculate closest
#'    percentile and return in list as `percentile`
#' @param return_median just return the median expected value
#' @param ... parameters passed to `read_who_table()`
#' @examples
#' pct_height_for_age(age = 5, sex = "female")
#' pct_height_for_age(age = 5, height = 112, sex = "female")
#' @autoglobal
#' @noRd
pct_height_for_age <- function(age = NULL,
                               height = NULL,
                               sex = NULL,
                               return_median = FALSE,
                               ...) {
  if (is.null(age)) {
    stop("Age required.")
  }
  if (length(age) == 1) {
    if (return_median) {
      pct <- pct_for_age_generic(age = age,
                                 sex = sex,
                                 variable = "height",
                                 ...)
    } else {
      pct <- pct_for_age_generic(age = age,
                                 value = height,
                                 sex = sex,
                                 variable = "height",
                                 ...)
    }
  } else {
    if (is.null(height)) {
      tmp <- lapply(age, pct_height_for_age, sex = sex)
    } else {
      stop("A specific height value cannot be supplied when age is a vector.")
    }
    pct <- data.frame(cbind("age" = age,
                            matrix(unlist(tmp),
                                   nrow = length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  if (return_median) {
    return(pct$P50)
  } else {
    return(pct)
  }
}

#' Percentile weight for age for children
#'
#' Based on tables from WHO:
#'    http://www.who.int/childgrowth/standards/weight_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param weight weight in kg. Optional, if specified, will calculate closest
#'    percentile and return in list as `percentile`
#' @param return_median just return the median expected value
#' @param ... parameters passed to `read_who_table()`
#' @examples
#' pct_weight_for_age(age = 5, sex = "female")
#' pct_weight_for_age(age = 5, weight = 20, sex = "female")
#' @autoglobal
#' @noRd
pct_weight_for_age <- function(age = NULL,
                               weight = NULL,
                               sex = NULL,
                               return_median = FALSE,
                               ...) {
  if (is.null(age)) {
    stop("Age required.")
  }
  if (length(age) == 1) {
    if (return_median) {
      pct <- pct_for_age_generic(age = age,
                                 sex = sex,
                                 variable = "weight",
                                 ...)
    } else {
      pct <- pct_for_age_generic(age = age,
                                 value = weight,
                                 sex = sex,
                                 variable = "weight",
                                 ...)
    }
  } else {
    if (is.null(weight)) {
      tmp <- lapply(age, pct_weight_for_age, sex = sex)
    } else {
      stop("A specific weight value cannot be supplied when age is a vector.")
    }
    pct <- data.frame(cbind("age" = age,
                            matrix(unlist(tmp),
                                   nrow = length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  if (return_median) {
    return(pct$P50)
  } else {
    return(pct)
  }
}
