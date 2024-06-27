library(readxl)
library(meta)

#1. load excel or csv file containing mean and SD of n-NRF magnitudes at each site
metamean_bysite <- read_excel("metamean_bysite.xlsx")

#   Oxford, UCL, Exeter. "metamean_bysite.xlxs"

meta_analysis <- metamean(n=n_hyp2,
                                mean = mean_hyp2,
                                sd = sd_hyp2,
                                studlab = site,
                                data = metamean_bysite,
                                sm = "MRAW",
                                fixed = TRUE,
                                random = TRUE,
                                method.tau = "REML",
                                hakn = TRUE,
                                title = "Pooled means across sites")
summary(meta_analysis)

forest(meta_analysis, 
            layout = "meta",
            xlab = "Mean EEG response",
            comb.fixed = TRUE,
            comb.random = TRUE,
            prediction = FALSE,
            xlim = c(0.4, 1.8),
            print.Q = TRUE,
            print.I2 = TRUE,
            print.I2.ci = TRUE,
            leftcols = c("studlab", "n"),
            weight.study = "common",
            col.square = "darkblue",
            col.diamond = "lightblue",
            leftlabs = c("Study site", "Total"),
            rightlabs = c("Mean", "95% CI",  "Weight \n (common)", "Weight \n (random)"),
            addrows.below.overall = 4,
            smlab = ""
)

#END#
