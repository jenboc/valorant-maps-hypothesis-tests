# Script for creating the chi-squared distribution visualisation
# in the article

library(ggplot2)

# Define degrees of freedom
dofs <- c(1, 2, 4, 6, 10, 20)

# Create a sequence of x values
x <- seq(0, 50, length.out = 1000)

# Calculate chi-squared density for each DoF
df <- expand.grid(x = x, dof = dofs)
df$density <- dchisq(df$x, df = df$dof)

# Plot the distributions
plot <- ggplot(df, aes(x = x, y = density, colour = factor(dof))) +
  geom_line(linewidth = 1) +
  labs(
    title = "Chi-squared Distributions",
    x = expression(chi^2),
    y = "Probability Density",
    colour = "Degrees of Freedom"
  ) +
  coord_cartesian(
    xlim = c(0, 30),
    ylim = c(0, 0.25)
  ) +
  theme_minimal(base_size = 13)

ggsave(
    filename = "chi-squared-distributions.png",
    plot = plot,
    width = 10,
    height = 6,
    units = "in",
    dpi = 300
)