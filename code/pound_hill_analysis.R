
# Author : Aiyanuj <aw2923@ic.ac.uk>
# Script: pound_hill_analysis.R
# Desc: Analyse the pound hill data to investigate plant species richness across treatments

# Scientific question:
# How does mean plant species richness per quadrat vary among the March, May and October cultivation treatments?



# Import data and metadata

MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")

MyData[MyData == ""] <- 0 #according to the metadata, blanks in species count are observed absence and should be converted to 0



# Convert data to long form

MyData <- t(MyData)
TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

require(reshape2)
require(dplyr)

MyWrangledData <- melt(
  TempData,
  id = c("Cultivation", "Block", "Plot", "Quadrat"),
  variable.name = "Species",
  value.name = "Count"
)

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])



# Check validity of count values

for (i in MyWrangledData$Count) {
    if (is.numeric(i) == FALSE) {
        stop("Species count ", i, " is not numeric")
    }
    else if (is.finite(i) == FALSE)  {
        stop("Species count ", i, " is not finite")
    }
    else if (i < 0) {
        stop("Species count ", i, " is negative")
    }
}


# Determine number of distinct species, quadrats and plots

print("Number of distinct species: ")
n_distinct(MyWrangledData$Species)

print("Number of distinct plots: ")
n_distinct(MyWrangledData$Plot)

print("Number of distinct quadrats: ")
n_distinct(MyWrangledData$Cultivation, MyWrangledData$Block, MyWrangledData$Plot, MyWrangledData$Quadrat)



# Quadrat level table with species richness

TibbleData <- as_tibble(MyWrangledData)

QuadratTable <- TibbleData %>%
    group_by(Cultivation, Block, Plot, Quadrat) %>%
    summarise(
        Richness = n_distinct(Species[Count > 0]),
        .groups = "keep"
    )



# Plot level table with mean richness

PlotSummary <- QuadratTable %>%
    group_by(Cultivation, Block, Plot) %>%
    summarise(
        MeanRichness = mean(Richness),
        .groups = "keep"
    )

dir.create("results", showWarnings = FALSE)

write.csv(PlotSummary, "results/pound_hill_plot_richness.csv", row.names = FALSE)
print("Saved plot-level mean richness table to results/pound_hill_plot_richness.csv")



# Create a figure comparing plot-level mean richness among the three cultivation treatments

require(ggplot2)

pdf("results/pound_hill_plot_richness.pdf",
4, 7)
ggplot(PlotSummary, aes(x = Cultivation, y = MeanRichness)) +
  geom_boxplot(fill = "#8bb7e4", alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.4, alpha = 0.5, color = "#235c94") +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  labs(x = "cultivation treatments", y = "mean species richness at plot level") +
  theme_classic() +
  scale_y_continuous(limits = c(0,NA)) 
graphics.off(); 

print("Saved a figure comparing plot-level mean richness among cultivation treatments to results/pound_hill_plot_richness.pdf")



# Interpret the results

# The May treatment has the highest richness.
# There is some variation in the plots within treatments. Notably, plot 6 has higher richness than other plots in the October treatment.
# The figure alone does not show that cultivation timing caused the differences. Correlation does not confirm causation.
# We need to perform statistical tests, examine the significance levels, look at the experimental design, relevant literature, and potential biological mechanisms, for instance.





# Extra: Examining total species abundance

QuadratTable_Abundance <- TibbleData %>%
    group_by(Cultivation, Block, Plot, Quadrat) %>%
    summarise(
        Abundance = sum(Count),
        .groups = "keep"
    )

PlotSummary_Abundance <- QuadratTable_Abundance %>%
    group_by(Cultivation, Block, Plot) %>%
    summarise(
        MeanAbundance = mean(Abundance),
        .groups = "keep"
    )

abundanceplot <- ggplot(PlotSummary_Abundance, aes(x = Cultivation, y = MeanAbundance)) +
  geom_boxplot(fill = "#8be497", alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.4, alpha = 0.5, color = "#2c9423") +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  labs(x = "cultivation treatments", y = "mean abundance at plot level") +
  theme_classic() +
  scale_y_continuous(limits = c(0,NA)) 

# different result from richness, October treatment has the highest abundance
# abundance data does not account for diversity in species or dominance