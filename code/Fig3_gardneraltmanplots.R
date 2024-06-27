library(readxl)
library(dabestr)
library(dplyr)
library(tidyr)

#1. load excel or csv file containing n-NRF magnitudes "both_sites_magnitudes.xlxs"
both_sites_magnitudes <- read.csv("both_sites_magnitudes.csv")

#2. create dataframes for UCL and Exeter magnitudes separately
UCL_magnitudes <- both_sites_magnitudes[both_sites_magnitudes$Site == "UCL", ]
exeter_magnitudes <- both_sites_magnitudes[both_sites_magnitudes$Site == "Exeter", ]

#3. create hypothesis 1 dataframe for each site individually
UCL_magnitudes_hyp1 <- UCL_magnitudes[UCL_magnitudes$hypothesis1_include == 1, ]
exeter_magnitudes_hyp1 <- exeter_magnitudes[exeter_magnitudes$hypothesis1_include == 1, ]

#4. Creating a variable for difference in magnitude between heel lance and control heel lance
UCL_magnitudes_hyp1$difference = UCL_magnitudes_hyp1$magnitude_HL - UCL_magnitudes_hyp1$magnitude_CL
exeter_magnitudes_hyp1$difference = exeter_magnitudes_hyp1$magnitude_HL - exeter_magnitudes_hyp1$magnitude_CL

#5. Find index of rows where EEG magnitude is increasing or decreasing
indx_increase_UCL <- UCL_magnitudes_hyp1$difference >= 0
indx_decrease_UCL <- UCL_magnitudes_hyp1$difference < 0
UCL_magnitudes_hyp1$pos_neg = NA
UCL_magnitudes_hyp1[indx_increase_UCL, "pos_neg"] <- 1
UCL_magnitudes_hyp1[indx_decrease_UCL, "pos_neg"] <- -1

UCL_magnitudes_hyp1$pos_neg <- as.factor(UCL_magnitudes_hyp1$pos_neg)

indx_increase_exeter <- exeter_magnitudes_hyp1$difference >= 0
indx_decrease_exeter <- exeter_magnitudes_hyp1$difference < 0
exeter_magnitudes_hyp1$pos_neg = NA
exeter_magnitudes_hyp1[indx_increase_exeter, "pos_neg"] <- 1
exeter_magnitudes_hyp1[indx_decrease_exeter, "pos_neg"] <- -1

exeter_magnitudes_hyp1$pos_neg <- as.factor(exeter_magnitudes_hyp1$pos_neg)

colnames(exeter_magnitudes_hyp1)[which(names(exeter_magnitudes_hyp1) == "magnitude_CL")] <- "magnitude_CL_exeter"
colnames(exeter_magnitudes_hyp1)[which(names(exeter_magnitudes_hyp1) == "magnitude_HL")] <- "magnitude_HL_exeter"

#6. tidy by group (CL or HL and magnitude)
my.data_UCL <-
  UCL_magnitudes_hyp1 %>%
  tidyr::gather(key = Group, value = Measurement, magnitude_CL, magnitude_HL, difference)

my.data_exeter <-
  exeter_magnitudes_hyp1 %>%
  tidyr::gather(key = Group, value = Measurement, magnitude_CL_exeter, magnitude_HL_exeter, difference)

#7. bind all 
my.data_all <- bind_rows(my.data_UCL, my.data_exeter)

#8. utilise dabestr function to create Gardner Altman plot
my_multi_two_group_paired.mean_diff <- load(my.data_all,
                                            x=Group, y=Measurement,
                                            idx = list(c("magnitude_CL", "magnitude_HL"), 
                                                       c("magnitude_CL_exeter", "magnitude_HL_exeter")),
                                            colour = pos_neg,
                                            paired = "baseline", id_col = studyID
) %>%
  mean_diff()


dabest_plot(my_multi_two_group_paired.mean_diff, 
            swarm_y_text = 14, contrast_y_text = 14,
            axes.title.fontsize = 12,
            swarm_label = "n-NRF magnitude",
            raw_marker_size = 0.3,
            #raw_bar_width = 0.1,
            custom_palette = "d3",
            slopegraph = TRUE)

#END#


