
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



print("Inspect Input:")
str(treedata)


# function to calculate tree heights
TreeHeightCalculation <- function(Distance.m, Angle.degrees) {
    height_m <- Distance.m * tan(Angle.degrees * pi /180)
    return(height_m)
}

height_m <- TreeHeightCalculation(treedata$Distance.m, treedata$Angle.degrees)



treedata.height <- treedata
treedata.height$height_m <- height_m


print("Inspect Output:")
str(treedata.height)


dir.create("results", showWarnings = FALSE)
write.csv(treedata.height, "results/TreeHts.csv", row.names = FALSE)
print("Output saved at results/TreeHts.csv")