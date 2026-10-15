# Script for the simulation used to test the hypothesis
# Run script from the repo root

# Read data from the csv file
data <- read.csv(
    "./data/maps.csv",
    header = FALSE,
    col.names = "map_name"
)
maps <- unique(data$map_name)
View(data)

# Function for calculating the test statistic for an observation
calc_statistic <- function(seq, maps) {
    # Create transition table
    current_map <- factor(seq[-length(seq)], levels = maps)
    next_map <- factor(seq[-1], levels = maps)
    trans_table <- table(current_map, next_map)

    # Calculate the expected number of counts under the assumption
    n_transitions <- length(seq) - 1
    expected <- matrix(
        n_transitions / length(maps)^2,
        nrow = length(maps),
        ncol = length(maps)
    )

    # Calculate Pearson chi-squared statistic
    sum((trans_table - expected)^2 / expected)
}

# Collect simulated statistics
n_sims <- 10000
simulated_stats <- replicate(n_sims, {
    simulated_seq <- sample(maps, length(data$map_name), replace = TRUE)
    calc_statistic(simulated_seq, maps)
})

# Calculate observation statistic and p-value
observed_stat <- calc_statistic(data$map_name, maps)
p_value <- (1 + sum(simulated_stats >= observed_stat)) / (n_sims + 1)

cat("Observed Statistic =", observed_stat, "\n")
cat("p-value =", p_value, "\n")

# Plot null distribution + observed statistic
plot_results <- function() {
    hist(
        simulated_stats,
        breaks = 40,
        main = "Null Distribution under Uniform-IID Assumption",
        xlab = "Chi-squared transition statistic"
    )
    
    abline(v = observed_stat, col = "red", lwd = 2)
    
    legend(
        "topright",
        legend = paste("Observed statistic =", round(observed_stat, 4)),
        col = "red",
        lwd = 2
    )
}

png("uniform-iid-histogram.png", width = 1200, height = 800, res = 150)
plot_results()
dev.off()

dev.new()
plot_results()