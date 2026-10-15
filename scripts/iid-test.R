# Script for running the test for iid of VALORANT map selection
# Run from the repo root

# Read the chronological data and extract the unique map names
map_chronology <- read.csv("./data/maps.csv", header = FALSE, col.names = "map_name")
observation <- map_chronology$map_name
maps <- unique(observation)

# Function to calculate the transition-table statistic
transition_stat <- function(seq, maps) {
    # Form a 1-lag transition table
    current_map <- factor(seq[-length(seq)], levels = maps)
    next_map <- factor(seq[-1], levels = maps)
    trans_table <- table(current_map, next_map)

    # Calculate the expected number of counts under independence assumption
    expected <- outer(
        rowSums(trans_table),
        colSums(trans_table)
    ) / sum(trans_table)

    # Calculate Pearson statistic
    sum((trans_table - expected)^2 / expected)
}

# Calculate the statistic for our observation
observed_stat <- transition_stat(observation, maps)
cat("Observed statistic:", observed_stat, "\n")

# Simulate using the H0: map selection is uniform iid
B <- 1000
simulated_stats <- replicate(B, {
    simulated_seq <- sample(maps, length(observation), replace = TRUE)
    transition_stat(simulated_seq, maps)
})
View(simulated_stats)

# Visualise the simulation statistics
hist(
    simulated_stats,
    breaks = 40,
    main = "Null Distribution under Uniform-IID assumption",
    xlab = "Chi-squared 1-lag transition statistic"
)
abline(v = observed_stat, col = "red", lwd = 2)

# Calculate the p-value
p_value <- (1 + sum(simulated_stats >= observed_stat)) / (B + 1)
cat("Simulation p-value: ", p_value, "\n")