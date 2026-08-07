# Load packages
library(dplyr)

# Load and view example data
data(mtcars)
head(mtcars)

# Calculate a simple summary
summary(mtcars$mpg)

# Filter rows
efficient_cars <- mtcars %>%
  filter(mpg > 25)

print(efficient_cars)

# Create a new column
cars_with_kpl <- mtcars %>%
  mutate(km_per_litre = mpg * 0.425)

head(cars_with_kpl)

# Group and summarise
mtcars %>%
  group_by(cyl) %>%
  summarise(
    average_mpg = mean(mpg),
    number_of_cars = n()
  )

# Make a basic plot
plot(
  mtcars$wt,
  mtcars$mpg,
  xlab = "Weight",
  ylab = "Miles per gallon",
  main = "Fuel Efficiency vs Car Weight"
)
