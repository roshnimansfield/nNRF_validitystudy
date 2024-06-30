library(readxl)
library(boot)

#1. load excel or csv file containing n-NRF magnitudes "both_sites_magnitudes.csv"
both_sites_magnitudes <- read.csv("both_sites_magnitudes.csv")

#2. create dataframe for Exeter magnitudes separately
exeter_magnitudes <- both_sites_magnitudes[both_sites_magnitudes$Site == "Exeter", ]

#3. create dataframe with only Exeter data for hypothesis 2
exeter_magnitudes_hyp2 <- exeter_magnitudes[exeter_magnitudes$hypothesis2_include == 1, ]

#4. bootstrapped confidence intervals - Exeter
mean.fun <- function(x, i) mean(x[i])
exeter_magnitudes_hyp2_vector <- as.vector(exeter_magnitudes_hyp2$magnitude_HL)
set.seed(2)
bootstrap <- boot(exeter_magnitudes_hyp2_vector, mean.fun, R=10000, stype = "i")
plot(bootstrap)
summary(bootstrap)
boot.ci(boot.out = bootstrap, conf = 0.90,
        type = c("bca"))

#END#
