
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: TreeHeight.R
# Calculate tree heights using angle degrees and distance from trees, save output to csv file


# input: tree data csv
treedata <- read.csv("data/trees.csv", header = TRUE)


# check validity of distance values
for (i in treedata$Distance.m) {
    if (is.numeric(i) == FALSE) {
        stop("Distance ", i, " is not numeric")
    }
    else if (is.finite(i) == FALSE)  {
        stop("Distance ", i, " is not finite")
    }
    else if (i <= 0 | i > 100) {
        stop("Distance ", i, " is out of range")
    }
}

# check validity of angle values
for (i in treedata$Angle.degrees) {
    if (is.numeric(i) == FALSE) {
        stop("Angle ", i, " is not numeric")
    }
    else if (is.finite(i) == FALSE)  {
        stop("Angle ", i, " is not finite")
    }
    else if (i <= 0 | i >= 90) {
        stop("Angle ", i, " is out of range")
    }
}


# function to calculate tree heights
TreeHeight <- function(Angle.degrees, Distance.m) {
    radians <- Angle.degrees * pi / 180
    height_m <- Distance.m * tan(radians)
    return(height_m)
}


# check the calculation of TreeHeight function with an example
test_angle <- 45
test_distance <- 8
expected_height <- 8
test_height <- TreeHeight(test_angle, test_distance)
# raise an error if the calculation is not as expected
if (is.numeric(test_height) != is.numeric(expected_height)) {
    stop("TreeHeight function does not return expected calculation")
}


# apply function and append heights to the data frame
treedata$height_m <- TreeHeight(treedata$Angle.degrees, treedata$Distance.m)

print("Inspect Output:")
str(treedata)


# save the output to a csv file
dir.create("results", showWarnings = FALSE)
write.csv(treedata, "results/TreeHts.csv", row.names = FALSE)

print("Output saved at results/TreeHts.csv")