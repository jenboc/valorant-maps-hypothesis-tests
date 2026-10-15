# Script for testing whether or not the map selection follows a uniform distribution
# Run script from repo root

# Read the chronological data
map_chronology <- read.csv("./data/maps.csv", header = FALSE, col.names = "map_name")
View(map_chronology)

# Create a frequency table of each map
observed_frequencies <- table(map_chronology$map_name)
View(observed_frequencies)

# Built-in chi-squared assumes uniform distribution by default
test_results <- chisq.test(observed_frequencies)
print(test_results) 