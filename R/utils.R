#' Remove NULL elements from vector ----------------------------------------
#' @autoglobal
#' @noRd
remove_null <- function(l) {Filter(Negate(is.null), l)}

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

#' param_brackets -----------------------------------------------------------
#' Some API parameters have spaces, these must be converted to "%20".
#' @param param parameter with a space
#' @return parameter formatted with "%20" in lieu of a space
#' @autoglobal
#' @noRd
param_brackets <- function(param,
                           right = TRUE,
                           left = TRUE,
                           asterisk = TRUE) {
  param <- gsub("[", "%5B", param, fixed = TRUE)
  param <- gsub("*", "%2A", param, fixed = TRUE)
  param <- gsub("]", "%5D", param, fixed = TRUE)
  return(param)
  }

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

#' sql_format ------------------------------------------------------------
#' @param param API parameter
#' @param arg API function arg
#' @return formatted API filters
#' @autoglobal
#' @noRd
sql_format <- function(param, arg) {
  if (is.null(arg)) {param <- NULL} else {
    paste0("[WHERE ", param, " = ", "%22", arg, "%22", "]")}}


#' assign_bmi_icd ----------------------------------------------------------
#' @param bmi body mass index
#' @return vector of assigned icd bmi codes
#' @autoglobal
#' @export
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

#' assign_bmi_status -------------------------------------------------------
#' @param bmi body mass index
#' @return vector of assigned bmi statuses
#' @autoglobal
#' @export
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
#' @export
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
