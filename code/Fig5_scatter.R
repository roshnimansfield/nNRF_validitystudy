library(readxl)
library(ggplot2)

#1. load excel or csv file containing n-NRF magnitudes "both_sites_magnitudes.csv"
both_sites_magnitudes <- read.csv("both_sites_magnitudes.csv")

#2. create df with only hypothesis 3 data for both sites selected
both_sites_magnitudes_hyp3 <- both_sites_magnitudes[both_sites_magnitudes$hypothesis3_include == 1, ]

#3. create scatter with line of best fit (lm)
ggplot(both_sites_magnitudes_hyp3, aes(x=`Gestational.age.at.study..weeks.`, y=magnitude_HL)) + 
  geom_point(aes(color = Site)) + 
  geom_smooth(method=lm, se=TRUE, fullrange = FALSE, linetype = "dashed", color = "black", linewidth = 0.5) + 
  labs(x="Postmenstrual age at study (weeks)", y="n-NRF magnitude")+ 
  scale_x_continuous(breaks = c(30,31,32,33,34,35,36,37))+
  theme_classic()

#END#
