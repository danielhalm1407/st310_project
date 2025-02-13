## LOADING PACKAGES ============================================================

library(tidyverse)
library(tidymodels)
library(GGally)

## LOADING DATASET =============================================================

## You only need to run the following line once to select the dataset.
## If `Heart` is ever removed under the `Environment` pane (from RStudio
## crashing or cleaning out objects) then re-run this line.

Heart <- read.csv(file.choose())

## DATASET OVERVIEW ============================================================

## This dataset has 1,025 observations and 14 available covariates/predictors
## with no missing values present
Heart %>%
	glimpse %>%
	summarize(total_NA = sum(is.na(.)))

## Here, we append new columns as factor-ed versions, namely:
##   1. $sex, with 0 = Female, 1 = Male,
##   2. $target, with 0 = Absent, 1 = Present
Heart <- Heart %>%
	mutate(sex_factor = recode(sex,
														 "0" = "Female",
														 "1" = "Male")) %>%
	mutate(target_factor = recode(target,
																"0" = "Absent",
																"1" = "Present"))

## EXPLORATORY DATA ANALYSIS ===================================================

## $age acts like expected with no identified outliers and within a reasonable
##      range
## $chol has the widest spread from approximately 125 to 350 mg/Dl contained
##      within the staple; has several identified outliers at the high end
## $oldpeak is barely visible on this graph though there appears to be an
##      outlier at the high end
## $thalach has the second-widest spread from approximately 175 to 200 bpm? and
##      an outier at the low end
## $trestbps has a narrow interquartile range with several outliers at the
##      high end
Heart %>%
	select(c(age, trestbps, chol, thalach, oldpeak)) %>%
	pivot_longer(cols = everything(), names_to = "Variable", values_to = "Value") %>%
	ggplot(aes(x = Variable, y = Value)) +
		geom_boxplot(fill = "lightblue", color = "black", outlier.color = "red", staplewidth = 0.5) +
	  scale_y_continuous(breaks = round(seq(0, 600, by = 50), 1)) +
		theme_minimal()

## $age appears approximately symmetric though it can be argued it is slightly
##      skewed left (actual mean is approximately 54.5 years old); unimodal
## $chol appears skewed right (actual mean is 246 mg/dL)
## $oldpeak appears heavily right skewed, specifically zero-inflated (actual
##     mean is 1.071 mm?); unimodal
## $thalach appears slightly left skewed (actual mean is 149 bpm?); unimodal
## $trestbps appears slightly right skewed (actual mean is 131 bmp?); unimodal
Heart %>%
	select(c(age, trestbps, chol, thalach, oldpeak)) %>%
	pivot_longer(cols = everything(), names_to = "Variable", values_to = "Value") %>%
	ggplot(aes(x = Value)) +
		geom_histogram(fill = "lightblue", color = "black") +
		facet_wrap(~Variable, scales="free_x") +
		theme_minimal()

## lesser-known predictors (to me) are moderately strong correlated to $target:
##      • $oldpeak -0.438
##      • $exang   -0.438
##      • $slope   -0.346
##      • $cp       0.435
##      • $thalach  0.423
##      • $ca      -0.382
##      • $exang   -0.338
Heart %>%
  select(-c(sex_factor, target_factor)) %>%
	ggpairs
