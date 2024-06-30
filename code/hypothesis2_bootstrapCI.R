library(readxl)
library(boot)

#1. load excel or csv file containing n-NRF magnitudes "both_sites_magnitudes.xlxs"
both_sites_magnitudes <- read.csv("both_sites_magnitudes.csv")

#2. create dataframes for UCL and Exeter magnitudes separately
UCL_magnitudes <- both_sites_magnitudes[both_sites_magnitudes$Site == "UCL", ]
exeter_magnitudes <- both_sites_magnitudes[both_sites_magnitudes$Site == "Exeter", ]

#3. create dataframe with only UCL data for hypothesis 2 
UCL_magnitudes_hyp2 <- UCL_magnitudes[UCL_magnitudes$hypothesis2_include == 1, ]

#4. bootstrapped confidence intervals - UCL
mean.fun <- function(x, i) mean(x[i])
UCL_magnitudes_hyp2_vector <- as.vector(UCL_magnitudes_hyp2$magnitude_HL)
set.seed(1)
bootstrap <- boot(UCL_magnitudes_hyp2_vector, mean.fun, R=10000, stype = "i")
plot(bootstrap)
summary(bootstrap)
boot.ci(boot.out = bootstrap, conf = 0.90,
        type = c("bca"))


#5. create dataframe with only Exeter data for hypothesis 2
exeter_magnitudes_hyp2 <- exeter_magnitudes[exeter_magnitudes$hypothesis2_include == 1, ]

#6. bootstrapped confidence intervals - Exeter
mean.fun <- function(x, i) mean(x[i])
exeter_magnitudes_hyp2_vector <- as.vector(exeter_magnitudes_hyp2$magnitude_HL)
set.seed(2)
bootstrap <- boot(exeter_magnitudes_hyp2_vector, mean.fun, R=10000, stype = "i")
plot(bootstrap)
summary(bootstrap)
boot.ci(boot.out = bootstrap, conf = 0.90,
        type = c("bca"))

#END#
