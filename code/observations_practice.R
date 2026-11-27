
# Author : Aiyanuj <aw2923@ic.ac.uk>
# Script: observations_practice.R
# Desc: Reading and summarising observations (known and missing counts)

# function to read a csv file and check for validity of the data
read_observations <- function(path) {
    data <- read.csv(
        path,
        colClasses = "character",
        na.strings = "",
        check.names = FALSE
    )

    expected_columns <- c("site", "date", "count")
    if (!identical(names(data), expected_columns)) {
        stop("Input must contain exactly the columns: site, date, count")
    }

    if (any(is.na(data$site) | !nzchar(trimws(data$site)))) {
        stop("Site values must not be empty")
    }
    if (any(is.na(data$date) | !nzchar(trimws(data$date)))) {
        stop("Date values must not be empty")
    }

    valid_counts <- is.na(data$count) | grepl("^(0|[1-9][0-9]*)$", data$count)
    if (any(!valid_counts)) {
        stop("Counts must be either non-negative whole numbers or missing")
    }

    data$count <- as.integer(data$count)
    data
}


# function to summarise observations by site, counting total known and missing counts
summarise_observations <- function(data) {
    data <- data[!duplicated(data), , drop = FALSE]
    sites <- unique(data$site)

    if (length(sites) == 0) {
        return(data.frame(
            site = character(),
            total_known = integer(),
            missing_count = integer()
        ))
    }

    summaries <- lapply(sites, function(site_name) {
        counts <- data$count[data$site == site_name]
        total_known <- if (all(is.na(counts))) {
            NA_integer_
        } else {
            sum(counts, na.rm = TRUE)
        }

        data.frame(
            site = site_name,
            total_known = as.integer(total_known),
            missing_count = sum(is.na(counts)),
            stringsAsFactors = FALSE
        )
    })

    do.call(rbind, summaries)
}




# check that invalid input is rejected

invalid_rejected <- tryCatch(
    {
        read_observations("data/bootcamp_observations_invalid.csv")
        FALSE
    },
    error = function(error) TRUE
)
stopifnot(invalid_rejected)



# apply the functions to observations data

observations <- read_observations("data/bootcamp_observations.csv")
observations_boundary <- read_observations("data/bootcamp_observations_boundary.csv")

summary <- rbind(
    summarise_observations(observations),
    summarise_observations(observations_boundary)
)

stopifnot(
    identical(summary$site, c("A", "B", "C", "D")),
    identical(summary$total_known, c(2L, 0L, NA_integer_, 0L)),
    identical(summary$missing_count, c(1L, 0L, 2L, 0L))
)

print(summary)



# plot base-R figure

all_missing_sites <- summary[is.na(summary$total_known), , drop = FALSE]
zero_total_sites <- summary[!is.na(summary$total_known) & summary$total_known == 0, , drop = FALSE]

missing_note <- if (nrow(all_missing_sites) == 0) {
    "Open circles mark zero totals; no site is entirely missing."
} else {
    missing_labels <- paste0(
        all_missing_sites$site,
        " (",
        all_missing_sites$missing_count,
        " missing)"
    )
    paste0(
        "Open circles mark zero totals; X marks all counts missing"
    )
}

dir.create("results", showWarnings = FALSE, recursive = TRUE)
max_total <- max(summary$total_known, na.rm = TRUE)
y_ticks <- pretty(c(0, max_total))
y_ticks <- y_ticks[y_ticks >= 0]
y_top <- max(1, max_total, max(y_ticks)) * 1.15
site_positions <- seq_len(nrow(summary))

png("results/observations_summary.png", width = 2100, height = 1500, res = 300)
par(mar = c(5, 4, 5, 2) + 0.1)
plot(
    NA,
    xlim = c(0.5, nrow(summary) + 0.5),
    ylim = c(-y_top * 0.06, y_top),
    xaxt = "n",
    yaxt = "n",
    xlab = "Site",
    ylab = "Known total",
    main = "Known observation totals by site"
)
axis(1, at = site_positions, labels = summary$site)
axis(2, at = y_ticks, labels = y_ticks, las = 1)
abline(h = y_ticks, col = "#E6E6E6", lty = 1)

positive_sites <- which(!is.na(summary$total_known) & summary$total_known > 0)
zero_sites <- which(!is.na(summary$total_known) & summary$total_known == 0)
if (length(positive_sites) > 0) {
    rect(
        site_positions[positive_sites] - 0.32,
        0,
        site_positions[positive_sites] + 0.32,
        summary$total_known[positive_sites],
        col = "#467B70",
        border = NA
    )
}

points(
    site_positions[zero_sites],
    rep(0, length(zero_sites)),
    pch = 21,
    bg = "white",
    col = "#467B70",
    cex = 1.4
)
points(
    site_positions[is.na(summary$total_known)],
    rep(0, nrow(all_missing_sites)),
    pch = 4,
    col = "#B34D36",
    lwd = 2,
    cex = 1.4
)
mtext(missing_note, side = 3, line = 0.3, cex = 0.85)
box()
dev.off()