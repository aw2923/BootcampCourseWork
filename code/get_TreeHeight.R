
# Author: Aiyanuj Wongkomet <aw2923@ic.ac.uk>
# Script: get_TreeHeight.R
# For ageneralised csv input, calculate tree heights using angle degrees and distance from trees, save output to csv file


# Accept input csv from user
input <- commandArgs(trailingOnly = TRUE)


# Check validity of input
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
    stop("Invalid headers, required headers: Species, Distance.m, Angle.degrees")
}


# Check validity of distance values
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

# Check validity of angle values
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


# Function to calculate tree heights
TreeHeight <- function(Angle.degrees, Distance.m) {
    radians <- Angle.degrees * pi / 180
    height_m <- Distance.m * tan(radians)
    return(height_m)
}

# Apply function and append heights to the data frame
treedata$height_m <- TreeHeight(treedata$Angle.degrees, treedata$Distance.m)

print("Inspect Output:")
str(treedata)


# Save the output to <basename_treeheights.csv> in results/
dir.create("results", showWarnings = FALSE)

base_name <- tools::file_path_sans_ext(basename(csv_path))
output_path <- file.path("results", paste0(base_name, "_treeheights.csv"))
write.csv(treedata, output_path, row.names = FALSE)

cat("Output saved at ", output_path, "\n", sep = "")
# note that input paths with the same basename would target the same result file name
