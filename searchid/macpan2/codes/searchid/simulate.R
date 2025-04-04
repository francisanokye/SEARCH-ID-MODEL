
#rpcall("simulate.Rout simulate.R timevar_spec.rds params.rda")

#timevar_spec <- rdsRead("timevar_spec.rds")

#print(timevar_spec$integers$report_prob_cp[1])


# Load necessary libraries
library(macpan2)
library(shellpipes)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(ggplot2)
library(conflicted)
library(broom.mixed)
set.seed(2025)

loadEnvironments()

timevar_spec <- rdsRead("timevar_spec.rds")  # Uses new parameters
seroprevdata <- rdsRead("seroprevdata.rds")
calibrator <- rdsRead("calibrator.rds")

outputs <- c("S", "E", "A", "R", "C", "H", "I", "D", "cases", "beta", "serop", "report_prob") 

# Simulate using the new parameters
simulation_results <- mp_simulate(
  calibrator,
  spec = timevar_spec |> mp_hazard(),
  outputs = outputs,
  time = mp_sim_bounds(-off, 200-off, "daily")
)

# Save the simulated data
rdsSave(simulation_results)

# Convert results into a dataframe for plotting
sim_data <- simulation_results %>%
  as.data.frame() %>%
  pivot_longer(cols = -c(time), names_to = "variable", values_to = "value")

# Plot simulation results
p <- ggplot() +
  # Simulated data
  geom_line(data = sim_data, aes(x = time, y = value, color = variable), linewidth = 1.2) +
  
  # Observed data (seroprev)
  geom_point(data = seroprevdata, aes(x = time, y = value), color = "black", size = 2, alpha = 0.6) +
  
  # Labels and theme
  labs(title = "Simulation with Calibrated Parameters",
       x = "Time (Days)",
       y = "Value",
       color = "Variable") +
  theme_clean() +
  theme(
    axis.text.x = element_text(size = 12),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 12),
    axis.title.y = element_text(size = 14, face = "bold"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    legend.position = "bottom"
  ) +
  facet_wrap(~variable, scales = "free_y") # Facet by each output variable

# Save the plot
ggsave("simulation_results.pdf", plot = p, width = 12, height = 8, dpi = 300)

# Print plot to console
print(p)
