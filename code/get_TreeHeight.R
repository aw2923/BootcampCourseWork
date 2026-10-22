input <- commandArgs(trailingOnly = TRUE)

if (length(input) != 1) {
    stop("must supply exactly 1 csv input file, use the format: Rscript get_TreeHeight.R <input.csv>")
}

csv_path <- input[1]
if (!file.exists(csv_path)) {
    stop("the supplied input file does not exist")
}

treedata <- read.csv(csv_path)

VALID_HEADERS <- c("Species", "Distance.m", "Angle.degrees")
if (!identical((colnames(treedata)), VALID_HEADERS)) {
    stop("Invalid headers")
}


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


# create output file <basename_treeheights.csv> in results
base_name <- tools::file_path_sans_ext(basename(csv_path))
dir.create("results", showWarnings = FALSE)
write.csv(treedata.height, file.path("results", paste0(base_name, "_treeheights.csv")), row.names = FALSE)
# note that input paths with the same basename would target the same result file name