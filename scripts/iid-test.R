# Script for running the test for iid of VALORANT map selection
# Run from the repo root

library(ggplot2)

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
plot_data <- data.frame(statistic = simulated_stats)

plot <- ggplot(plot_data, aes(x = statistic)) +
    geom_histogram(
        bins = 40,
        fill = "steelblue",
        colour = "white"
    ) +
    geom_vline(
        aes(
            xintercept = observed_stat,
            colour = "Observed statistic"
        ),
        linewidth = 1
    ) +
    scale_colour_manual(
        name = NULL,
        values = c("Observed statistic" = "red")
    ) +
    labs(
        title = "Null Distribution under Uniform IID Selection",
        x = "Chi-squared transition statistic",
        y = "Frequency"
    ) +
    theme_minimal(base_size = 14)

print(plot)
ggsave(
    "uniform-iid-histogram.png",
    plot = plot,
    width = 10,
    height = 6,
    units = "in",
    dpi = 150
)

# Calculate the p-value
p_value <- (1 + sum(simulated_stats >= observed_stat)) / (B + 1)
cat("Simulation p-value: ", p_value, "\n")